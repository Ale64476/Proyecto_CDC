-- REPARACION COMPLETA Proyecto_CDC
-- Borra y restaura centrocomunitario desde el backup actual y recrea vistas compatibles.

DROP DATABASE IF EXISTS centrocomunitario;

-- Backup de la base de datos centrocomunitario
-- Generado desde Proyecto_CDC
-- Fecha: 2026-05-22T13:40:58.663318300

CREATE DATABASE IF NOT EXISTS `centrocomunitario`
CHARACTER SET utf8mb4
COLLATE utf8mb4_spanish_ci;

USE `centrocomunitario`;

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `actividad`;
CREATE TABLE `actividad` (
  `id_actividad` int NOT NULL AUTO_INCREMENT,
  `nombre_actividad` varchar(150) COLLATE utf8mb4_spanish_ci NOT NULL,
  `descripcion_actividad` text COLLATE utf8mb4_spanish_ci,
  `id_instructor` int NOT NULL,
  `estado_actividad` enum('Activa','Inactiva') COLLATE utf8mb4_spanish_ci NOT NULL DEFAULT 'Activa',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_desactivacion` datetime DEFAULT NULL,
  PRIMARY KEY (`id_actividad`),
  KEY `idx_actividad_instructor` (`id_instructor`),
  KEY `idx_actividad_estado` (`estado_actividad`),
  KEY `idx_actividad_nombre` (`nombre_actividad`),
  CONSTRAINT `fk_actividad_instructor` FOREIGN KEY (`id_instructor`) REFERENCES `instructor` (`id_instructor`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO `actividad` VALUES ('1', 'Manualidades', 'Taller creativo para desarrollar habilidades manuales y expresión artística.', '1', 'Activa', '2026-05-08T14:55:23', NULL);
INSERT INTO `actividad` VALUES ('2', 'Boxeo', 'Actividad física orientada al acondicionamiento, disciplina y técnica básica.', '2', 'Activa', '2026-05-08T14:55:23', NULL);
INSERT INTO `actividad` VALUES ('3', 'Computación', 'Curso introductorio al uso de herramientas digitales y computación básica.', '3', 'Activa', '2026-05-08T14:55:23', NULL);
INSERT INTO `actividad` VALUES ('4', 'Música', 'Espacio para explorar ritmo, canto e iniciación musical.', '4', 'Inactiva', '2026-05-08T14:55:23', '2026-05-08T14:55:23');
INSERT INTO `actividad` VALUES ('5', 'Corte de cabello', 'Taller de corte de cabello (3 meses)', '1', 'Activa', '2026-05-09T20:37:55', NULL);
INSERT INTO `actividad` VALUES ('6', 'Programaciòn', 'Curso basico de htmml y java', '1', 'Activa', '2026-05-14T12:05:17', NULL);
INSERT INTO `actividad` VALUES ('7', 'Taller de prueba', NULL, '5', 'Activa', '2026-05-21T22:49:14', NULL);

DROP TABLE IF EXISTS `administrador`;
CREATE TABLE `administrador` (
  `id_admin` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_spanish_ci NOT NULL,
  `usuario_login` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `contrasena` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `estado_admin` enum('Activo','Inactivo') COLLATE utf8mb4_spanish_ci NOT NULL DEFAULT 'Activo',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_admin`),
  UNIQUE KEY `usuario_login` (`usuario_login`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO `administrador` VALUES ('1', 'Administrador General', 'admin', 'admin123', 'Activo', '2026-05-08T14:55:23');

DROP TABLE IF EXISTS `alumno`;
CREATE TABLE `alumno` (
  `id_alumno` int NOT NULL AUTO_INCREMENT,
  `nombre_completo` varchar(150) COLLATE utf8mb4_spanish_ci NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `curp` char(18) COLLATE utf8mb4_spanish_ci NOT NULL,
  `domicilio` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `celular` varchar(15) COLLATE utf8mb4_spanish_ci NOT NULL,
  `estado_alumno` enum('Activo','Inactivo','Baja') COLLATE utf8mb4_spanish_ci NOT NULL DEFAULT 'Activo',
  `fecha_baja` datetime DEFAULT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_alumno`),
  UNIQUE KEY `uq_alumno_curp` (`curp`),
  KEY `idx_alumno_estado` (`estado_alumno`),
  KEY `idx_alumno_nombre` (`nombre_completo`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO `alumno` VALUES ('1', 'Carla Gómez', '2009-05-12', 'GOGC090512MQRMLRA3', 'Calle 24 #123, Col. Centro, Chetumal, Quintana Roo, C.P. 77000', '9991234567', 'Activo', NULL, '2026-05-08T14:55:23');
INSERT INTO `alumno` VALUES ('2', 'José Pérez', '2009-08-21', 'PEJJ090821HQRRSL02', 'Av. Reforma #45, Col. Las Palmas, Chetumal, Quintana Roo, C.P. 77010', '9992345678', 'Activo', NULL, '2026-05-08T14:55:23');
INSERT INTO `alumno` VALUES ('3', 'Andrea Ruiz', '2008-02-03', 'RUIA080203MQRNND04', 'Calle 8 #19, Col. Del Bosque, Chetumal, Quintana Roo, C.P. 77013', '9813456789', 'Activo', NULL, '2026-05-08T14:55:23');
INSERT INTO `alumno` VALUES ('4', 'Mateo Chan', '2010-11-17', 'CHAM101117HQRNTT07', 'Calle 10 #88, Col. Proterritorio, Chetumal, Quintana Roo, C.P. 77017', '9994567890', 'Activo', NULL, '2026-05-08T14:55:23');
INSERT INTO `alumno` VALUES ('5', 'Sofía Castillo', '2009-06-29', 'CASS090629MQRTRL01', 'Calle 30 #54, Col. Solidaridad, Chetumal, Quintana Roo, C.P. 77020', '9995678901', 'Inactivo', NULL, '2026-05-08T14:55:23');
INSERT INTO `alumno` VALUES ('6', 'Lucía Martínez', '2008-04-14', 'MALU080414MQRRCC05', 'Calle 60 #12, Col. Centro, Chetumal, Quintana Roo, C.P. 77000', '9996789012', 'Baja', '2026-05-08T14:55:23', '2026-05-08T14:55:23');
INSERT INTO `alumno` VALUES ('7', 'Alejandro Jesus Ordoñez Azar', '2004-12-21', 'OOAA041221HCCRZLA1', 'Calle 2 entre 5 y 104 Col. Bellavista #39', '9811334228', 'Activo', NULL, '2026-05-09T20:03:18');

DROP TABLE IF EXISTS `asistencia`;
CREATE TABLE `asistencia` (
  `id_asistencia` int NOT NULL AUTO_INCREMENT,
  `id_alumno` int NOT NULL,
  `id_actividad` int NOT NULL,
  `fecha_asistencia` date NOT NULL,
  `asistio` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_registro_asistencia` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_admin` int NOT NULL,
  PRIMARY KEY (`id_asistencia`),
  UNIQUE KEY `uq_asistencia_alumno_actividad_fecha` (`id_alumno`,`id_actividad`,`fecha_asistencia`),
  KEY `idx_asistencia_alumno` (`id_alumno`),
  KEY `idx_asistencia_actividad` (`id_actividad`),
  KEY `idx_asistencia_fecha` (`fecha_asistencia`),
  KEY `idx_asistencia_admin` (`id_admin`),
  CONSTRAINT `fk_asistencia_actividad` FOREIGN KEY (`id_actividad`) REFERENCES `actividad` (`id_actividad`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_asistencia_admin` FOREIGN KEY (`id_admin`) REFERENCES `administrador` (`id_admin`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_asistencia_alumno` FOREIGN KEY (`id_alumno`) REFERENCES `alumno` (`id_alumno`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO `asistencia` VALUES ('1', '1', '1', '2026-05-05', 'true', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('2', '2', '1', '2026-05-05', 'true', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('3', '3', '1', '2026-05-05', 'true', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('4', '1', '1', '2026-05-07', 'true', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('5', '2', '1', '2026-05-07', 'true', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('6', '3', '1', '2026-05-07', 'false', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('7', '1', '1', '2026-05-12', 'true', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('8', '2', '1', '2026-05-12', 'true', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('9', '3', '1', '2026-05-12', 'true', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('10', '2', '2', '2026-05-06', 'true', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('11', '4', '2', '2026-05-06', 'true', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('12', '2', '2', '2026-05-08', 'true', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('13', '4', '2', '2026-05-08', 'false', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('14', '1', '3', '2026-05-09', 'true', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('15', '3', '3', '2026-05-09', 'true', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('16', '1', '3', '2026-05-16', 'true', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('17', '3', '3', '2026-05-16', 'false', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('18', '1', '4', '2026-05-07', 'true', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('19', '3', '4', '2026-05-07', 'true', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('20', '5', '4', '2026-05-07', 'true', '2026-05-08T14:55:23', '1');
INSERT INTO `asistencia` VALUES ('21', '7', '2', '2026-05-09', 'true', '2026-05-09T22:00:42', '1');
INSERT INTO `asistencia` VALUES ('22', '2', '2', '2026-05-09', 'false', '2026-05-09T22:00:42', '1');
INSERT INTO `asistencia` VALUES ('23', '4', '2', '2026-05-09', 'false', '2026-05-09T22:00:42', '1');
INSERT INTO `asistencia` VALUES ('24', '7', '2', '2026-05-10', 'true', '2026-05-10T04:39:18', '1');
INSERT INTO `asistencia` VALUES ('25', '2', '2', '2026-05-10', 'false', '2026-05-10T04:39:18', '1');
INSERT INTO `asistencia` VALUES ('26', '4', '2', '2026-05-10', 'false', '2026-05-10T04:39:18', '1');
INSERT INTO `asistencia` VALUES ('27', '7', '5', '2026-05-10', 'true', '2026-05-10T13:16:51', '1');
INSERT INTO `asistencia` VALUES ('28', '3', '5', '2026-05-10', 'true', '2026-05-10T13:37:25', '1');
INSERT INTO `asistencia` VALUES ('29', '7', '2', '2026-05-11', 'false', '2026-05-11T17:48:54', '1');
INSERT INTO `asistencia` VALUES ('30', '3', '2', '2026-05-11', 'true', '2026-05-11T17:48:54', '1');
INSERT INTO `asistencia` VALUES ('31', '1', '2', '2026-05-11', 'true', '2026-05-11T17:48:54', '1');
INSERT INTO `asistencia` VALUES ('32', '2', '2', '2026-05-11', 'true', '2026-05-11T17:48:54', '1');
INSERT INTO `asistencia` VALUES ('33', '4', '2', '2026-05-11', 'true', '2026-05-11T17:48:54', '1');
INSERT INTO `asistencia` VALUES ('34', '7', '6', '2026-05-14', 'false', '2026-05-14T12:06:21', '1');
INSERT INTO `asistencia` VALUES ('35', '3', '6', '2026-05-14', 'true', '2026-05-14T12:06:21', '1');
INSERT INTO `asistencia` VALUES ('36', '1', '6', '2026-05-14', 'false', '2026-05-14T12:06:21', '1');

DROP TABLE IF EXISTS `aviso`;
CREATE TABLE `aviso` (
  `id_aviso` int NOT NULL AUTO_INCREMENT,
  `titulo` varchar(150) COLLATE utf8mb4_spanish_ci NOT NULL,
  `mensaje` text COLLATE utf8mb4_spanish_ci NOT NULL,
  `estado_aviso` enum('Publicado','Borrador','Archivado') COLLATE utf8mb4_spanish_ci NOT NULL DEFAULT 'Publicado',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_inicio` datetime DEFAULT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  PRIMARY KEY (`id_aviso`),
  KEY `idx_aviso_estado` (`estado_aviso`),
  KEY `idx_aviso_fecha` (`fecha_creacion`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO `aviso` VALUES ('1', 'Cupo limitado en Manualidades', 'Se recomienda revisar la disponibilidad de materiales para el taller de Manualidades.', 'Publicado', '2026-05-08T14:55:30', '2026-05-08T14:55:30', NULL);
INSERT INTO `aviso` VALUES ('2', 'Actividad próxima sin asistencia', 'Verificar el registro de asistencia de la actividad del día.', 'Publicado', '2026-05-08T14:55:30', '2026-05-08T14:55:30', NULL);
INSERT INTO `aviso` VALUES ('3', 'Revisión de horarios', 'Actualizar horarios del próximo mes antes del cierre administrativo.', 'Borrador', '2026-05-08T14:55:30', '2026-05-08T14:55:30', NULL);

DROP TABLE IF EXISTS `evento`;
CREATE TABLE `evento` (
  `id_evento` int NOT NULL AUTO_INCREMENT,
  `nombre_evento` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion_evento` text COLLATE utf8mb4_unicode_ci,
  `fecha_evento` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time DEFAULT NULL,
  `lugar` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `responsable` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_evento` enum('Borrador','Publicado','Finalizado','Cancelado') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Borrador',
  `texto_publicacion` text COLLATE utf8mb4_unicode_ci,
  `url_formulario` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `google_form_id` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url_hoja_respuestas` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `google_sheet_id` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `facebook_post_id` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `idx_evento_estado` (`estado_evento`),
  KEY `idx_evento_fecha` (`fecha_evento`),
  KEY `idx_evento_google_form` (`google_form_id`),
  KEY `idx_evento_google_sheet` (`google_sheet_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `evento` VALUES ('1', 'Dia de las madresss', 'Habran rifas, musica y mucho amor para las mamás', '2026-05-29', '13:00:00', '15:00:00', 'Centro comunitario plan chac', 'Alejandro Ordoñez', 'Finalizado', 'Te invitamos a participar en el evento Dia de las madresss, que se realizará en el Centro Comunitario Plan Chac.\n\nFecha: 2026-05-29\nHora: 13:00:00\n\nHabrá:\nHabran rifas, musica y mucho amor para las mamás\n\nEsperamos contar con tu presencia.\n\nPor favor registra tu asistencia en:\nhttps://forms.gle/fr7gm7D6pRN59H8q8\n', 'https://forms.gle/fr7gm7D6pRN59H8q8', '', 'https://docs.google.com/spreadsheets/d/1u3wbyZgg1h4DhNREPXey4y7pKOLDNXzrg_kxsGc2vAA/edit?usp=sharing', '', '', '2026-05-22T12:48:51', '2026-05-22T12:50:44');

DROP TABLE IF EXISTS `evento_imagen`;
CREATE TABLE `evento_imagen` (
  `id_imagen_evento` int NOT NULL AUTO_INCREMENT,
  `id_evento` int NOT NULL,
  `nombre_archivo` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ruta_relativa` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orden_imagen` int NOT NULL DEFAULT '1',
  `estado_imagen` enum('Activa','Inactiva') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Activa',
  `fecha_subida` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_imagen_evento`),
  KEY `idx_evento_imagen_evento` (`id_evento`),
  KEY `idx_evento_imagen_estado` (`estado_imagen`),
  CONSTRAINT `fk_evento_imagen_evento` FOREIGN KEY (`id_evento`) REFERENCES `evento` (`id_evento`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `gerontologia_consulta`;
CREATE TABLE `gerontologia_consulta` (
  `id_consulta` int NOT NULL AUTO_INCREMENT,
  `id_paciente` int NOT NULL,
  `fecha_consulta` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `nombre_paciente_snapshot` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `edad_paciente_snapshot` int NOT NULL,
  `motivo_consulta` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `antecedentes` text COLLATE utf8mb4_unicode_ci,
  `notas` text COLLATE utf8mb4_unicode_ci,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_consulta`),
  KEY `idx_gerontologia_consulta_paciente` (`id_paciente`),
  KEY `idx_gerontologia_consulta_fecha` (`fecha_consulta`),
  CONSTRAINT `fk_gerontologia_consulta_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `gerontologia_paciente` (`id_paciente`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `gerontologia_consulta` VALUES ('1', '1', '2026-05-22T03:45:55', 'Carla Gómez', '17', 'Dolor de cabeza agudo', 'Hipertensa', 'Ninguna', '2026-05-22T03:45:55', '2026-05-22T03:46:02');

DROP TABLE IF EXISTS `gerontologia_paciente`;
CREATE TABLE `gerontologia_paciente` (
  `id_paciente` int NOT NULL AUTO_INCREMENT,
  `id_alumno` int NOT NULL,
  `estado_paciente` enum('Activo','Archivado') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Activo',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_paciente`),
  UNIQUE KEY `uq_gerontologia_paciente_alumno` (`id_alumno`),
  KEY `idx_gerontologia_paciente_estado` (`estado_paciente`),
  KEY `idx_gerontologia_paciente_alumno` (`id_alumno`),
  CONSTRAINT `fk_gerontologia_paciente_alumno` FOREIGN KEY (`id_alumno`) REFERENCES `alumno` (`id_alumno`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `gerontologia_paciente` VALUES ('1', '1', 'Activo', '2026-05-22T03:43:50', '2026-05-22T03:46:16');
INSERT INTO `gerontologia_paciente` VALUES ('2', '2', 'Activo', '2026-05-22T03:43:50', '2026-05-22T03:43:50');

DROP TABLE IF EXISTS `horario_actividad`;
CREATE TABLE `horario_actividad` (
  `id_horario_actividad` int NOT NULL AUTO_INCREMENT,
  `id_actividad` int NOT NULL,
  `dia_semana` enum('Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo') COLLATE utf8mb4_spanish_ci NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  PRIMARY KEY (`id_horario_actividad`),
  UNIQUE KEY `uq_horario_actividad` (`id_actividad`,`dia_semana`,`hora_inicio`,`hora_fin`),
  KEY `idx_horario_actividad_actividad` (`id_actividad`),
  KEY `idx_horario_actividad_dia` (`dia_semana`),
  CONSTRAINT `fk_horario_actividad_actividad` FOREIGN KEY (`id_actividad`) REFERENCES `actividad` (`id_actividad`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_horario_actividad_tiempo` CHECK ((`hora_fin` > `hora_inicio`))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO `horario_actividad` VALUES ('1', '1', 'Lunes', '10:00:00', '12:00:00');
INSERT INTO `horario_actividad` VALUES ('2', '1', 'Miércoles', '16:00:00', '18:00:00');
INSERT INTO `horario_actividad` VALUES ('3', '2', 'Martes', '17:00:00', '18:30:00');
INSERT INTO `horario_actividad` VALUES ('4', '2', 'Jueves', '17:00:00', '18:30:00');
INSERT INTO `horario_actividad` VALUES ('5', '3', 'Lunes', '16:00:00', '18:00:00');
INSERT INTO `horario_actividad` VALUES ('6', '3', 'Viernes', '12:00:00', '14:00:00');
INSERT INTO `horario_actividad` VALUES ('7', '4', 'Miércoles', '15:00:00', '16:30:00');
INSERT INTO `horario_actividad` VALUES ('8', '4', 'Viernes', '15:00:00', '16:30:00');
INSERT INTO `horario_actividad` VALUES ('11', '5', 'Lunes', '12:00:00', '14:00:00');
INSERT INTO `horario_actividad` VALUES ('12', '5', 'Sábado', '12:00:00', '14:00:00');
INSERT INTO `horario_actividad` VALUES ('15', '6', 'Lunes', '18:00:00', '20:00:00');
INSERT INTO `horario_actividad` VALUES ('16', '7', 'Lunes', '10:00:00', '12:00:00');

DROP TABLE IF EXISTS `inscripcion`;
CREATE TABLE `inscripcion` (
  `id_inscripcion` int NOT NULL AUTO_INCREMENT,
  `id_alumno` int NOT NULL,
  `id_actividad` int NOT NULL,
  `fecha_inscripcion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado_inscripcion` enum('Activa','Cancelada','Finalizada') COLLATE utf8mb4_spanish_ci NOT NULL DEFAULT 'Activa',
  PRIMARY KEY (`id_inscripcion`),
  KEY `idx_inscripcion_alumno` (`id_alumno`),
  KEY `idx_inscripcion_actividad` (`id_actividad`),
  KEY `idx_inscripcion_estado` (`estado_inscripcion`),
  CONSTRAINT `fk_inscripcion_actividad` FOREIGN KEY (`id_actividad`) REFERENCES `actividad` (`id_actividad`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_inscripcion_alumno` FOREIGN KEY (`id_alumno`) REFERENCES `alumno` (`id_alumno`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO `inscripcion` VALUES ('1', '1', '1', '2026-05-08T14:55:23', 'Activa');
INSERT INTO `inscripcion` VALUES ('2', '1', '3', '2026-05-08T14:55:23', 'Activa');
INSERT INTO `inscripcion` VALUES ('3', '1', '4', '2026-05-08T14:55:23', 'Activa');
INSERT INTO `inscripcion` VALUES ('4', '2', '1', '2026-05-08T14:55:23', 'Activa');
INSERT INTO `inscripcion` VALUES ('5', '2', '2', '2026-05-08T14:55:23', 'Activa');
INSERT INTO `inscripcion` VALUES ('6', '3', '1', '2026-05-08T14:55:23', 'Activa');
INSERT INTO `inscripcion` VALUES ('7', '3', '3', '2026-05-08T14:55:23', 'Activa');
INSERT INTO `inscripcion` VALUES ('8', '3', '4', '2026-05-08T14:55:23', 'Activa');
INSERT INTO `inscripcion` VALUES ('9', '4', '2', '2026-05-08T14:55:23', 'Activa');
INSERT INTO `inscripcion` VALUES ('10', '5', '4', '2026-05-08T14:55:23', 'Activa');
INSERT INTO `inscripcion` VALUES ('11', '7', '2', '2026-05-09T21:33:33', 'Activa');
INSERT INTO `inscripcion` VALUES ('12', '7', '5', '2026-05-10T13:16:46', 'Activa');
INSERT INTO `inscripcion` VALUES ('13', '3', '5', '2026-05-10T13:37:21', 'Activa');
INSERT INTO `inscripcion` VALUES ('14', '7', '3', '2026-05-10T14:44:40', 'Cancelada');
INSERT INTO `inscripcion` VALUES ('15', '7', '1', '2026-05-10T17:25:06', 'Activa');
INSERT INTO `inscripcion` VALUES ('16', '3', '2', '2026-05-11T17:48:30', 'Activa');
INSERT INTO `inscripcion` VALUES ('17', '1', '2', '2026-05-11T17:48:30', 'Activa');
INSERT INTO `inscripcion` VALUES ('18', '7', '6', '2026-05-14T12:06:10', 'Activa');
INSERT INTO `inscripcion` VALUES ('19', '3', '6', '2026-05-14T12:06:10', 'Activa');
INSERT INTO `inscripcion` VALUES ('20', '1', '6', '2026-05-14T12:06:10', 'Activa');

DROP TABLE IF EXISTS `instructor`;
CREATE TABLE `instructor` (
  `id_instructor` int NOT NULL AUTO_INCREMENT,
  `nombre_completo` varchar(150) COLLATE utf8mb4_spanish_ci NOT NULL,
  `celular` varchar(15) COLLATE utf8mb4_spanish_ci NOT NULL,
  `estado_instructor` enum('Activo','Inactivo') COLLATE utf8mb4_spanish_ci NOT NULL DEFAULT 'Activo',
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_instructor`),
  KEY `idx_instructor_estado` (`estado_instructor`),
  KEY `idx_instructor_nombre` (`nombre_completo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO `instructor` VALUES ('1', 'Ana López', '9991111111', 'Activo', '2026-05-08T14:55:23');
INSERT INTO `instructor` VALUES ('2', 'Carlos Hernández', '9992222222', 'Activo', '2026-05-08T14:55:23');
INSERT INTO `instructor` VALUES ('3', 'Diego Ramírez', '9993333333', 'Activo', '2026-05-08T14:55:23');
INSERT INTO `instructor` VALUES ('4', 'Luis Morales', '9994444444', 'Activo', '2026-05-08T14:55:23');
INSERT INTO `instructor` VALUES ('5', 'Alejandro Ordoñez', '9811334228', 'Activo', '2026-05-21T22:33:22');

SET FOREIGN_KEY_CHECKS=1;


-- ============================================================
-- VISTAS COMPATIBLES CON EL CODIGO ACTUAL
-- ============================================================

-- Proyecto_CDC
-- Reparación de vistas compatibles con el código actual.
-- Ejecutar DESPUÉS de restaurar las tablas de centrocomunitario.

USE centrocomunitario;

SET NAMES utf8mb4;

DROP VIEW IF EXISTS vw_actividad_detalle;
DROP VIEW IF EXISTS vw_calendario_completo;
DROP VIEW IF EXISTS vw_catalogo_instructores;
DROP VIEW IF EXISTS vw_dashboard_actividades_hoy;
DROP VIEW IF EXISTS vw_dashboard_avisos;
DROP VIEW IF EXISTS vw_dashboard_proximas_actividades;
DROP VIEW IF EXISTS vw_dashboard_resumen;
DROP VIEW IF EXISTS vw_reporte_actividades;
DROP VIEW IF EXISTS vw_reporte_alumnos;
DROP VIEW IF EXISTS vw_reporte_alumnos_por_actividad;
DROP VIEW IF EXISTS vw_reporte_asistencia_por_actividad;

-- ============================================================
-- ACTIVIDADES / TALLERES
-- ============================================================

CREATE VIEW vw_actividad_detalle AS
SELECT
    a.id_actividad,
    a.nombre_actividad,
    a.descripcion_actividad,
    a.estado_actividad,
    a.fecha_creacion,
    a.fecha_desactivacion,
    i.id_instructor,
    i.nombre_completo AS nombre_instructor,
    i.celular AS celular_instructor,
    COUNT(
        DISTINCT CASE
            WHEN ins.estado_inscripcion = 'Activa'
             AND al.estado_alumno = 'Activo'
            THEN ins.id_alumno
            ELSE NULL
        END
    ) AS total_inscritos,
    COALESCE(
        GROUP_CONCAT(
            DISTINCT CONCAT(
                h.dia_semana,
                ' ',
                TIME_FORMAT(h.hora_inicio, '%H:%i'),
                ' - ',
                TIME_FORMAT(h.hora_fin, '%H:%i')
            )
            ORDER BY
                CASE h.dia_semana
                    WHEN 'Lunes' THEN 1
                    WHEN 'Martes' THEN 2
                    WHEN 'Miércoles' THEN 3
                    WHEN 'Jueves' THEN 4
                    WHEN 'Viernes' THEN 5
                    WHEN 'Sábado' THEN 6
                    WHEN 'Domingo' THEN 7
                    ELSE 8
                END,
                h.hora_inicio
            SEPARATOR ' / '
        ),
        'Sin horario'
    ) AS horarios_resumen
FROM actividad a
INNER JOIN instructor i
    ON i.id_instructor = a.id_instructor
LEFT JOIN inscripcion ins
    ON ins.id_actividad = a.id_actividad
LEFT JOIN alumno al
    ON al.id_alumno = ins.id_alumno
LEFT JOIN horario_actividad h
    ON h.id_actividad = a.id_actividad
GROUP BY
    a.id_actividad,
    a.nombre_actividad,
    a.descripcion_actividad,
    a.estado_actividad,
    a.fecha_creacion,
    a.fecha_desactivacion,
    i.id_instructor,
    i.nombre_completo,
    i.celular;


CREATE VIEW vw_catalogo_instructores AS
SELECT
    id_instructor,
    nombre_completo,
    celular,
    estado_instructor,
    fecha_registro
FROM instructor;


-- ============================================================
-- DASHBOARD
-- ============================================================

CREATE VIEW vw_dashboard_resumen AS
SELECT
    (
        SELECT COUNT(*)
        FROM alumno
        WHERE estado_alumno = 'Activo'
    ) AS total_alumnos_registrados,

    (
        SELECT COUNT(*)
        FROM actividad
        WHERE estado_actividad = 'Activa'
    ) AS total_actividades_activas,

    (
        SELECT COUNT(DISTINCT a.id_actividad)
        FROM actividad a
        INNER JOIN horario_actividad h
            ON h.id_actividad = a.id_actividad
        WHERE a.estado_actividad = 'Activa'
          AND h.dia_semana = ELT(
                WEEKDAY(CURDATE()) + 1,
                'Lunes',
                'Martes',
                'Miércoles',
                'Jueves',
                'Viernes',
                'Sábado',
                'Domingo'
          )
    ) AS actividades_de_hoy,

    (
        SELECT COUNT(*)
        FROM asistencia
        WHERE fecha_asistencia = CURDATE()
    ) AS asistencias_registradas_hoy;


CREATE VIEW vw_dashboard_actividades_hoy AS
SELECT
    a.id_actividad,
    a.nombre_actividad,
    i.nombre_completo AS instructor,
    h.dia_semana,
    h.hora_inicio,
    h.hora_fin
FROM actividad a
INNER JOIN instructor i
    ON i.id_instructor = a.id_instructor
INNER JOIN horario_actividad h
    ON h.id_actividad = a.id_actividad
WHERE a.estado_actividad = 'Activa'
  AND h.dia_semana = ELT(
        WEEKDAY(CURDATE()) + 1,
        'Lunes',
        'Martes',
        'Miércoles',
        'Jueves',
        'Viernes',
        'Sábado',
        'Domingo'
  );


CREATE VIEW vw_dashboard_proximas_actividades AS
SELECT
    a.id_actividad,
    a.nombre_actividad,
    i.nombre_completo AS instructor,
    h.dia_semana,
    h.hora_inicio,
    h.hora_fin,
    CASE h.dia_semana
        WHEN 'Lunes' THEN 1
        WHEN 'Martes' THEN 2
        WHEN 'Miércoles' THEN 3
        WHEN 'Jueves' THEN 4
        WHEN 'Viernes' THEN 5
        WHEN 'Sábado' THEN 6
        WHEN 'Domingo' THEN 7
        ELSE 8
    END AS orden_dia
FROM actividad a
INNER JOIN instructor i
    ON i.id_instructor = a.id_instructor
INNER JOIN horario_actividad h
    ON h.id_actividad = a.id_actividad
WHERE a.estado_actividad = 'Activa';


CREATE VIEW vw_dashboard_avisos AS
SELECT
    id_aviso,
    titulo,
    mensaje,
    estado_aviso,
    fecha_creacion,
    fecha_inicio,
    fecha_fin
FROM aviso
WHERE estado_aviso = 'Publicado'
  AND (fecha_inicio IS NULL OR fecha_inicio <= NOW())
  AND (fecha_fin IS NULL OR fecha_fin >= NOW())
ORDER BY fecha_creacion DESC;


-- ============================================================
-- CALENDARIO
-- ============================================================

CREATE VIEW vw_calendario_completo AS
SELECT
    a.id_actividad,
    a.nombre_actividad,
    a.estado_actividad,
    a.id_instructor,
    i.nombre_completo AS nombre_instructor,
    h.id_horario_actividad,
    h.dia_semana,
    h.hora_inicio,
    h.hora_fin,
    CASE h.dia_semana
        WHEN 'Lunes' THEN 1
        WHEN 'Martes' THEN 2
        WHEN 'Miércoles' THEN 3
        WHEN 'Jueves' THEN 4
        WHEN 'Viernes' THEN 5
        WHEN 'Sábado' THEN 6
        WHEN 'Domingo' THEN 7
        ELSE 8
    END AS orden_dia
FROM actividad a
INNER JOIN instructor i
    ON i.id_instructor = a.id_instructor
INNER JOIN horario_actividad h
    ON h.id_actividad = a.id_actividad;


-- ============================================================
-- REPORTES
-- ============================================================

CREATE VIEW vw_reporte_alumnos AS
SELECT
    id_alumno,
    nombre_completo,
    fecha_nacimiento,
    curp,
    domicilio,
    celular,
    estado_alumno,
    fecha_baja
FROM alumno;


CREATE VIEW vw_reporte_actividades AS
SELECT
    a.id_actividad,
    a.nombre_actividad,
    i.nombre_completo AS instructor,

    COALESCE(
        GROUP_CONCAT(
            DISTINCT CONCAT(
                h.dia_semana,
                ' ',
                TIME_FORMAT(h.hora_inicio, '%H:%i'),
                ' - ',
                TIME_FORMAT(h.hora_fin, '%H:%i')
            )
            ORDER BY
                CASE h.dia_semana
                    WHEN 'Lunes' THEN 1
                    WHEN 'Martes' THEN 2
                    WHEN 'Miércoles' THEN 3
                    WHEN 'Jueves' THEN 4
                    WHEN 'Viernes' THEN 5
                    WHEN 'Sábado' THEN 6
                    WHEN 'Domingo' THEN 7
                    ELSE 8
                END,
                h.hora_inicio
            SEPARATOR ' / '
        ),
        'Sin horario'
    ) AS horarios,

    COUNT(
        DISTINCT CASE
            WHEN ins.estado_inscripcion = 'Activa'
             AND al.estado_alumno = 'Activo'
            THEN ins.id_alumno
            ELSE NULL
        END
    ) AS cantidad_inscritos,

    a.estado_actividad
FROM actividad a
INNER JOIN instructor i
    ON i.id_instructor = a.id_instructor
LEFT JOIN horario_actividad h
    ON h.id_actividad = a.id_actividad
LEFT JOIN inscripcion ins
    ON ins.id_actividad = a.id_actividad
LEFT JOIN alumno al
    ON al.id_alumno = ins.id_alumno
GROUP BY
    a.id_actividad,
    a.nombre_actividad,
    i.nombre_completo,
    a.estado_actividad;


CREATE VIEW vw_reporte_alumnos_por_actividad AS
SELECT
    al.id_alumno,
    al.nombre_completo AS nombre_alumno,
    al.celular,
    al.estado_alumno,
    a.id_actividad,
    a.nombre_actividad,
    i.nombre_completo AS instructor,

    COUNT(
        CASE
            WHEN asis.asistio = 1
             AND MONTH(asis.fecha_asistencia) = MONTH(CURDATE())
             AND YEAR(asis.fecha_asistencia) = YEAR(CURDATE())
            THEN 1
            ELSE NULL
        END
    ) AS asistencias_del_mes
FROM inscripcion ins
INNER JOIN alumno al
    ON al.id_alumno = ins.id_alumno
INNER JOIN actividad a
    ON a.id_actividad = ins.id_actividad
INNER JOIN instructor i
    ON i.id_instructor = a.id_instructor
LEFT JOIN asistencia asis
    ON asis.id_alumno = al.id_alumno
   AND asis.id_actividad = a.id_actividad
WHERE ins.estado_inscripcion = 'Activa'
GROUP BY
    al.id_alumno,
    al.nombre_completo,
    al.celular,
    al.estado_alumno,
    a.id_actividad,
    a.nombre_actividad,
    i.nombre_completo;


CREATE VIEW vw_reporte_asistencia_por_actividad AS
SELECT
    asis.id_asistencia,
    al.id_alumno,
    al.nombre_completo AS nombre_alumno,
    a.id_actividad,
    a.nombre_actividad,
    asis.fecha_asistencia,
    asis.fecha_asistencia AS fecha,
    asis.asistio,
    asis.fecha_registro_asistencia,
    adm.nombre AS registrado_por
FROM asistencia asis
INNER JOIN alumno al
    ON al.id_alumno = asis.id_alumno
INNER JOIN actividad a
    ON a.id_actividad = asis.id_actividad
INNER JOIN administrador adm
    ON adm.id_admin = asis.id_admin;


-- ============================================================
-- COMPROBACIÓN RÁPIDA
-- ============================================================

SHOW FULL TABLES WHERE Table_type = 'VIEW';

SELECT * FROM vw_dashboard_resumen;

SELECT COUNT(*) AS total_vw_actividad_detalle
FROM vw_actividad_detalle;

SELECT COUNT(*) AS total_vw_calendario_completo
FROM vw_calendario_completo;

SELECT COUNT(*) AS total_vw_reporte_actividades
FROM vw_reporte_actividades;

SELECT COUNT(*) AS total_vw_reporte_alumnos
FROM vw_reporte_alumnos;

SELECT COUNT(*) AS total_vw_reporte_alumnos_por_actividad
FROM vw_reporte_alumnos_por_actividad;

SELECT COUNT(*) AS total_vw_reporte_asistencia_por_actividad
FROM vw_reporte_asistencia_por_actividad;
