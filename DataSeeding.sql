-- SEEDING DE LA BASE DE DATOS

INSERT INTO departamentos (nombre_depto, servicio) VALUES
('Anestesiologia', 'Soporte Quirurgico'),
('Hematologia', 'Diagnostico Especializado'),
('Oncologia', 'Diagnostico y tratamiento'),
('Neumologia', 'Consulta Especializada'),
('Cardiologia', 'Diagnostico y tratamiento'),
('Pediatria', 'Atencion medica general'),
('Medicina Interna', 'Consulta general'),
('Cirugia', 'Intervencion quirurgica'),
('Dermatologia', 'Consulta especializada'),
('Oftalmologia', 'Consulta y cirugia especializada'),
('Urologia', 'Consulta y cirugia especializada'),
('Otorrinolaringologia', 'Consulta y cirugia especializada');

WITH datos(tipo_sala, capacidad, nombre_depto) AS (
    VALUES
    ('UCI', 10, 'Anestesiologia'),
    ('Quirofano', 5, 'Cirugia'),
    ('Urgencias', 20, 'Cirugia'),
    ('Consulta Externa', 15, 'Medicina Interna'),
    ('Imagenologia', 8, 'Oftalmologia'),
    ('Laboratorio', 12, 'Hematologia'),
    ('UCI', 10, 'Cirugia'),
    ('Quirofano', 5, 'Cardiologia'),
    ('Urgencias', 20, 'Cardiologia'),
    ('Consulta Externa', 15, 'Medicina Interna'),
    ('Imagenologia', 8, 'Oftalmologia'),
    ('Laboratorio', 12, 'Urologia')
)
INSERT INTO sala (tipo_sala, capacidad, id_depto)
SELECT 
    d.tipo_sala, 
    d.capacidad, 
    dep.id_depto
FROM datos d
JOIN departamentos dep 
    ON dep.nombre_depto = d.nombre_depto;


INSERT INTO cama (codigo_cama, estado_cama, tipo_cama, id_sala) VALUES
('CAMA-001', 'Disponible', 'Articulada', 1),
('CAMA-002', 'Disponible', 'Bariatrica', 1),
('CAMA-003', 'En Mantenimiento', 'Levitacion', 1),
('CAMA-004', 'Disponible', 'Articulada', 2),
('CAMA-005', 'En Mantenimiento', 'Bariatrica', 2),
('CAMA-006', 'En Mantenimiento', 'Levitacion', 2),
('CAMA-007', 'Disponible', 'Articulada', 3),
('CAMA-008', 'Ocupada', 'Bariatrica', 3),
('CAMA-009', 'En Mantenimiento', 'Levitacion', 3),
('CAMA-010', 'Disponible', 'Pediatrica', 4);

WITH datos_personal(matricula, especialidad, nombre, apellido, estado_laboral) AS (
    VALUES
    ('MAT-001', 'Anestesiologia', 'Kimberly', 'Gallardo Cervantes', 'Activo'),
    ('MAT-002', 'Hematologia', 'Ignacio Eduardo', 'Briseno Salcedo', 'Activo'),
    ('MAT-003', 'Oncologia', 'Carlos', 'Pelush Cortez', 'Activo'),
    ('MAT-004', 'Neumologia', 'Isaias Ezequiel', 'Perez Zarate', 'Licencia'),
    ('MAT-005', 'Cardiologia', 'Luis', 'Garcia Zague', 'Activo'),
    ('MAT-006', 'Pediatria', 'Sofia', 'Rodriguez Rodriguez', 'Activo'),
    ('MAT-007', 'Medicina Interna', 'Patricio', 'Salomon Estrella', 'Activo'),
    ('MAT-008', 'Cirugia', 'Laura', 'Bozo Polo', 'Activo'),
    ('MAT-009', 'Dermatologia', 'Diego', 'Luchitas Rodriguez', 'Activo'),
    ('MAT-010', 'Oftalmologia', 'Ryomen', 'Gojo Sukuna', 'Activo')
)
INSERT INTO personal (matricula, especialidad, nombre, apellido, estado_laboral, id_depto)
SELECT
    dp.matricula,
    dp.especialidad,
    dp.nombre,
    dp.apellido,
    dp.estado_laboral,
    dep.id_depto
FROM datos_personal dp
JOIN departamentos dep
    ON dep.nombre_depto = dp.especialidad;


