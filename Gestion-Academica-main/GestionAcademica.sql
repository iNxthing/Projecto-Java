drop database if exists gestion_academica;
create database if not exists gestion_academica;
use gestion_academica;

create table perfil (
    idPerfil int auto_increment primary key,
    nombrePerfil varchar(30) not null
);

insert into perfil (idPerfil, nombrePerfil) values 
(1, 'ADMINISTRADOR'),
(2, 'PROFESOR');

create table grado (
    id_grado int auto_increment primary key,
    nombre varchar(45) not null
);

insert into grado (nombre) values ('Sexto'), ('Séptimo');

create table periodo (
    id_periodo int auto_increment primary key,
    nombre varchar(30) not null
);

insert into periodo (nombre) values ('Periodo 1'), ('Periodo 2'), ('Periodo 3'), ('Periodo 4');

create table asignatura (
    id_asignatura int auto_increment primary key,
    nombre varchar(50) not null,
    id_grado int not null,
    foreign key (id_grado) references grado(id_grado)
);

insert into asignatura (nombre, id_grado) values ('Matemáticas', 1), ('Español', 1);

create table usuario (
    idUsuario int auto_increment primary key,
    documento varchar(20) null,
    nombre varchar(100) not null,
    usr varchar(45) not null unique,
    pass varchar(45) not null,
    idPerfil int not null,
    idAsignatura int null,
    foreign key (idPerfil) references perfil(idPerfil),
    foreign key (idAsignatura) references asignatura(id_asignatura)
);

insert into usuario (documento, nombre, usr, pass, idPerfil, idAsignatura) 
values ('0000', 'Administrador', 'admin', '1234', 1, null);

create table estudiante (
    id_estudiante int auto_increment primary key,
    documento varchar(20) not null unique,
    nombre varchar(100) not null,
    id_grado int not null,
    foreign key (id_grado) references grado(id_grado)
);

create table nota (
    id_nota int auto_increment primary key,
    id_estudiante int not null,
    id_asignatura int not null,
    id_periodo int not null,
    valor_nota decimal(4, 2) not null,
    unique (id_estudiante, id_asignatura, id_periodo),
    foreign key (id_estudiante) references estudiante(id_estudiante),
    foreign key (id_asignatura) references asignatura(id_asignatura),
    foreign key (id_periodo) references periodo(id_periodo)
);

delimiter //

drop procedure if exists sp_login //
create procedure sp_login(
    in p_usuario varchar(45),
    in p_clave varchar(45)
)
begin
    select 
        idUsuario,
        idPerfil,
        idUsuario as idProfesor
    from usuario
    where usr = p_usuario and pass = p_clave;
end //

drop procedure if exists sp_agregar_profesor //
create procedure sp_agregar_profesor(
    in p_documento varchar(20),
    in p_nombre varchar(100),
    in p_usuario varchar(45),
    in p_clave varchar(45),
    in p_id_asignatura int
)
begin
    insert into usuario (documento, nombre, usr, pass, idPerfil, idAsignatura)
    values (p_documento, p_nombre, p_usuario, p_clave, 2, p_id_asignatura);
end //

drop procedure if exists sp_listar_profesores //
create procedure sp_listar_profesores()
begin
    select 
        u.documento as Documento, 
        u.nombre as Profesor, 
        a.nombre as Asignatura, 
        u.usr as Usuario,
        u.pass as Clave
    from usuario u
    inner join asignatura a on u.idAsignatura = a.id_asignatura
    where u.idPerfil = 2
    order by u.nombre;
end //

drop procedure if exists sp_matricular_estudiante //
create procedure sp_matricular_estudiante(
    in p_documento varchar(20),
    in p_nombre varchar(100),
    in p_id_grado int
)
begin
    insert into estudiante (documento, nombre, id_grado)
    values (p_documento, p_nombre, p_id_grado);
end //

drop procedure if exists sp_matriculados //
create procedure sp_matriculados()
begin
    select 
        e.documento as Documento, 
        e.nombre as Estudiante, 
        g.nombre as Grado
    from estudiante e
    inner join grado g on e.id_grado = g.id_grado
    order by e.nombre;
end //

drop procedure if exists sp_guardar_nota //
create procedure sp_guardar_nota(
    in p_id_estudiante int,
    in p_id_asignatura int,
    in p_id_periodo int,
    in p_valor_nota decimal(4, 2)
)
begin
    insert into nota (id_estudiante, id_asignatura, id_periodo, valor_nota)
    values (p_id_estudiante, p_id_asignatura, p_id_periodo, p_valor_nota)
    on duplicate key update valor_nota = p_valor_nota;
end //

drop procedure if exists sp_listar_para_notas //
create procedure sp_listar_para_notas(
    in p_id_asignatura int,
    in p_id_periodo int
)
begin
    select 
        e.id_estudiante as idEstudiante,
        e.documento as Documento,
        e.nombre as Estudiante,
        n.valor_nota as Nota
    from estudiante e
    inner join asignatura a on e.id_grado = a.id_grado
    left join nota n on (e.id_estudiante = n.id_estudiante 
                     and n.id_asignatura = p_id_asignatura 
                     and n.id_periodo = p_id_periodo)
    where a.id_asignatura = p_id_asignatura
    order by e.nombre;
end //

drop procedure if exists sp_filtro_matriculados //
create procedure sp_filtro_matriculados(
    in p_id_grado int,
    in p_id_asignatura int
)
begin
    select 
        e.documento as Documento,
        e.nombre as Estudiante,
        g.nombre as Grado,
        a.nombre as Asignatura,
        ifnull(u.nombre, 'Sin asignar') as Profesor
    from estudiante e
    inner join grado g on e.id_grado = g.id_grado
    inner join asignatura a on g.id_grado = a.id_grado
    left join usuario u on (a.id_asignatura = u.idAsignatura and u.idPerfil = 2)
    where g.id_grado = p_id_grado
      and a.id_asignatura = p_id_asignatura
    order by g.nombre, a.nombre, e.nombre;
end //


drop procedure if exists sp_reporte_rendimiento //
create procedure sp_reporte_rendimiento(
    in p_nota_minima decimal(4, 2),
    in p_id_grado int,
    in p_id_asignatura int,
    in p_id_estudiante int,
    in p_id_periodo int
)
begin
    select 
        e.documento as Documento,
        e.nombre as Estudiante,
        g.nombre as Grado,
        a.nombre as Asignatura,
        per.nombre as Periodo,
        n.valor_nota as Nota,
        case 
            when n.valor_nota >= p_nota_minima then 'APROBADO'
            else 'REPROBADO'
        end as Estado
    from nota n
    inner join estudiante e on n.id_estudiante = e.id_estudiante
    inner join grado g on e.id_grado = g.id_grado
    inner join asignatura a on n.id_asignatura = a.id_asignatura
    inner join periodo per on n.id_periodo = per.id_periodo
    where g.id_grado = p_id_grado
      and a.id_asignatura = p_id_asignatura
      and e.id_estudiante = p_id_estudiante
      and per.id_periodo = p_id_periodo
    order by g.nombre, a.nombre, per.nombre, e.nombre;
end //

drop procedure if exists sp_combo_grados //
create procedure sp_combo_grados()
begin
    select 
        id_grado as idGrado, 
        nombre as nombreGrado
    from grado 
    order by id_grado;
end //

drop procedure if exists sp_combo_periodos //
create procedure sp_combo_periodos()
begin
    select 
        id_periodo as idPeriodo, 
        nombre as nombrePeriodo 
    from periodo 
    order by id_periodo;
end //

drop procedure if exists sp_combo_asignaturas //
create procedure sp_combo_asignaturas()
begin
    select 
        a.id_asignatura as idAsignatura, 
        concat(a.nombre, ' (', g.nombre, ')') as nombreAsignatura,
        g.nombre as nombreGrado
    from asignatura a
    inner join grado g on a.id_grado = g.id_grado
    order by a.nombre;
end //

drop procedure if exists sp_listar_asignaturas //
create procedure sp_listar_asignaturas()
begin
    select 
        a.id_asignatura as Id, 
        a.nombre as Nombre
    from asignatura a;
end //

drop procedure if exists sp_combo_estudiantes //
create procedure sp_combo_estudiantes()
begin
    select 
        id_estudiante as idEstudiante, 
        concat(documento, ' - ', nombre) as nombreEstudiante 
    from estudiante 
    order by nombre;
end //

drop procedure if exists sp_combo_asignaturas_profesor //
create procedure sp_combo_asignaturas_profesor(in p_id_profesor int)
begin
    select 
        a.id_asignatura as idAsignatura, 
        concat(a.nombre, ' (', g.nombre, ')') as nombreAsignatura
    from usuario u
    inner join asignatura a on u.idAsignatura = a.id_asignatura
    inner join grado g on a.id_grado = g.id_grado
    where u.idUsuario = p_id_profesor;
end //

drop procedure if exists sp_agregar_grado //
create procedure sp_agregar_grado(
    in p_nombre varchar(45)
)
begin
    insert into grado (nombre) values (p_nombre);
end //

drop procedure if exists sp_agregar_asignatura //
create procedure sp_agregar_asignatura(
    in p_nombre varchar(50),
    in p_id_grado int
)
begin
    insert into asignatura (nombre, id_grado) values (p_nombre, p_id_grado);
end //

delimiter ;
