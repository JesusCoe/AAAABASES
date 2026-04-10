-- SCHEMA SQL DE LA BASE DE DATOS PARA EL SISTEMA HOSPITALARIO

DROP DATABASE IF EXISTS sistema_hospitalario; 
-- Eliminar la base de datos si ya existe para evitar errores al crearla nuevamente

CREATE DATABASE sistema_hospitalario
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LOCALE_PROVIDER= 'libc'
    CONNECTION LIMIT = -1;
    TEMPLATE = template0;

\c sistema_hospitalario;

-- Tablas
CREATE TABLE departamentos(
    id_depto SERIAL PRIMARY KEY UNIQUE NOT NULL,
    nombre_depto VARCHAR(50) UNIQUE NOT NULL,
    servicio VARCHAR(40) NOT NULL,
);

CREATE TABLE sala(
    id_sala SERIAL PRIMARY KEY UNIQUE NOT NULL,
    tipo_sala VARCHAR(40) NOT NULL 
    CHECK (tipo_sala IN ('UCI', 'Quirofano', 
    'Urgencias', 'Consulta Externa', 'Imagenologia', 'Laboratorio')
    ),
    capacidad INT CHECK (capacidad > 0),
    id_depto INT NOT NULL,

    CONSTRAINT fk_depto
        FOREIGN KEY (id_depto)
        REFERENCES departamentos (id_depto)
);

CREATE TABLE cama(
    id_cama SERIAL PRIMARY KEY UNIQUE NOT NULL,
    codigo_cama VARCHAR(20) UNIQUE NOT NULL,
    estado_cama VARCHAR(20) NOT NULL 
    CHECK (estado_cama IN ('Disponible', 'Ocupada', 'En Mantenimiento')),
    tipo_cama VARCHAR(30) NOT NULL,

    id_sala INT NOT NULL,
    CONSTRAINT fk_sala
        FOREIGN KEY (id_sala)
        REFERENCES sala (id_sala)
);

CREATE TABLE paciente(
    id_paciente SERIAL PRIMARY KEY UNIQUE NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    apellido VARCHAR(40) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    CURP VARCHAR(18) UNIQUE NOT NULL
);

CREATE TABLE ingreso(
    id_ingreso SERIAL PRIMARY KEY UNIQUE NOT NULL,
    fecha_ingreso TIMESTAMP NOT NULL DEFAULT NOW(),
    motivo_ingreso VARCHAR(255) NOT NULL,
    estado VARCHAR(20) NOT NULL
    CHECK (estado IN ('Activo', 'Alta', 'Transferencia', 'Fallecido')),

    id_cama INT NOT NULL,
    CONSTRAINT fk_cama_ingreso
        FOREIGN KEY (id_cama)
        REFERENCES cama (id_cama),

    id_paciente INT NOT NULL,
    CONSTRAINT fk_paciente_ingreso
        FOREIGN KEY (id_paciente)
        REFERENCES paciente (id_paciente)
);

CREATE TABLE alta(
    id_alta SERIAL PRIMARY KEY UNIQUE NOT NULL,
    fecha_alta TIMESTAMP NOT NULL DEFAULT NOW(),
    condicion_alta VARCHAR(50) NOT NULL,
    indicaciones VARCHAR(255),

    id_ingreso INT NOT NULL,
    CONSTRAINT fk_ingreso_alta
        FOREIGN KEY (id_ingreso)
        REFERENCES ingreso(id_ingreso)
    
);

CREATE TABLE personal(
    id_personal SERIAL PRIMARY KEY UNIQUE NOT NULL,
    matricula VARCHAR(30) UNIQUE NOT NULL,
    especialidad VARCHAR(40) NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    apellido VARCHAR(40) NOT NULL,

    estado_laboral VARCHAR(20) NOT NULL 
    CHECK (estado_laboral IN ('Activo', 'Inactivo', 'Licencia', 'Vacaciones', 'Retirado')),

    id_depto INT NOT NULL,
    CONSTRAINT fk_depto_personal
        FOREIGN KEY (id_depto)
        REFERENCES departamentos (id_depto)
);

CREATE TABLE agenda(
    id_agenda SERIAL PRIMARY KEY UNIQUE NOT NULL,
    fecha_inicio TIMESTAMP NOT NULL DEFAULT NOW(),
    fecha_fin TIMESTAMP,
    capacidad INT NOT NULL CHECK (capacidad > 0),

    id_personal INT NOT NULL,
    CONSTRAINT fk_personal_agenda
        FOREIGN KEY (id_personal)
        REFERENCES personal (id_personal),

    CONSTRAINT chk_fecha_agenda
        CHECK (fecha_fin IS NULL OR fecha_fin > fecha_inicio)

);

CREATE TABLE cita(
    id_cita SERIAL PRIMARY KEY UNIQUE NOT NULL,
    fecha_cita TIMESTAMP NOT NULL DEFAULT NOW(),
    estado VARCHAR(20) NOT NULL 
    CHECK (estado IN ('Programada', 'Confirmada', 'Cancelada',
     'No asistio', 'Completada', 'Reprogramada')),

     id_agenda INT NOT NULL,
        CONSTRAINT fk_agenda_cita
        FOREIGN KEY (id_agenda)
        REFERENCES agenda(id_agenda),

    id_paciente INT NOT NULL,
    CONSTRAINT fk_paciente_consulta
        FOREIGN KEY (id_paciente)
        REFERENCES paciente (id_paciente)
);

CREATE TABLE consulta(
    id_consulta SERIAL PRIMARY KEY UNIQUE NOT NULL,
    fecha_consulta TIMESTAMP NOT NULL DEFAULT NOW(),
    motivo VARCHAR(255) NOT NULL,

    id_cita INT UNIQUE NOT NULL,
    CONSTRAINT fk_cita_consulta
        FOREIGN KEY (id_cita)
        REFERENCES cita (id_cita)

);

CREATE TABLE factura(
    id_factura SERIAL PRIMARY KEY UNIQUE NOT NULL,
    fecha_factura TIMESTAMP NOT NULL DEFAULT NOW(),
    importe DECIMAL(10, 2) NOT NULL CHECK (importe >= 0),

    id_consulta INT UNIQUE NOT NULL,
    CONSTRAINT fk_consulta_factura
        FOREIGN KEY (id_consulta)
        REFERENCES consulta (id_consulta)
);
