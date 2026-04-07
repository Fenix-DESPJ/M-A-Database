-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 07-04-2026 a las 14:26:23
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `barbershopmya`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarTelefonoUsuario` (`pId` INT, `pNuevoCel` VARCHAR(15))   BEGIN
    UPDATE Usuario SET numCelular = pNuevoCel WHERE idUsuario = pId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminarPagoPendiente` (`pId` INT)   BEGIN
    DELETE FROM Pago WHERE idPago = pId AND estadoPago = 'PENDIENTE';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `HistorialCitaPorCliente` (IN `pIdCliente` INT)   BEGIN
    SELECT c.idCita, u.nombre AS Cliente, c.fecha, c.horaInicio, s.nombreServicio, c.observaciones
    FROM Cita c
    INNER JOIN Cliente cl ON c.idClienteFk = cl.idCliente
    INNER JOIN Usuario u ON cl.idUsuarioFk = u.idUsuario
    INNER JOIN Servicio s ON c.idServicioFk = s.idServicio 
    WHERE cl.idCliente = pIdCliente
    ORDER BY c.fecha DESC, c.horaInicio DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarServicioExpress` (`pNom` VARCHAR(60), `pPrecio` DECIMAL(10,2))   BEGIN
    INSERT INTO Servicio (nombreServicio, duracion, precio, tipoServicio) 
    VALUES (pNom, 30, pPrecio, 'Express');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `VerCitasHoy` ()   BEGIN
    SELECT c.idCita, u.nombre AS nombreCliente, s.nombreServicio, c.horaInicio, bu.nombre AS nombreBarbero
    FROM Cita c
    INNER JOIN Cliente cl ON c.idClienteFk = cl.idCliente
    INNER JOIN Usuario u ON cl.idUsuarioFk = u.idUsuario
    INNER JOIN Servicio s ON c.idServicioFk = s.idServicio
    INNER JOIN Barbero b ON c.idBarberoFk = b.idBarbero
    INNER JOIN Usuario bu ON b.idUsuarioFk = bu.idUsuario;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `agenda`
--

CREATE TABLE `agenda` (
  `idAgenda` int(11) NOT NULL,
  `idBarberoFk` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `horaInicio` time DEFAULT NULL,
  `horaFin` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `agenda`
--

INSERT INTO `agenda` (`idAgenda`, `idBarberoFk`, `fecha`, `horaInicio`, `horaFin`) VALUES
(1, 1, '2026-03-20', '09:00:00', '13:00:00'),
(2, 2, '2026-03-20', '10:00:00', '14:00:00'),
(3, 1, '2026-03-21', '09:00:00', '13:00:00'),
(4, 2, '2026-03-21', '15:00:00', '19:00:00'),
(5, 1, '2026-03-22', '09:00:00', '13:00:00'),
(6, 2, '2026-03-22', '10:00:00', '14:00:00'),
(7, 1, '2026-03-23', '09:00:00', '13:00:00'),
(8, 2, '2026-03-23', '10:00:00', '14:00:00'),
(9, 1, '2026-03-24', '09:00:00', '13:00:00'),
(10, 2, '2026-03-24', '10:00:00', '14:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `barbero`
--

CREATE TABLE `barbero` (
  `idBarbero` int(11) NOT NULL,
  `idUsuarioFk` int(11) DEFAULT NULL,
  `especialidad` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `barbero`
--

INSERT INTO `barbero` (`idBarbero`, `idUsuarioFk`, `especialidad`) VALUES
(1, 2, 'Master Fade'),
(2, 5, 'Barba Clásica'),
(3, 2, 'Cortes Modernos'),
(4, 5, 'Tijera'),
(5, 2, 'Pigmentación'),
(6, 5, 'Tratamientos'),
(7, 2, 'Niños'),
(8, 5, 'Navaja'),
(9, 2, 'Diseño'),
(10, 5, 'Color');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cita`
--

CREATE TABLE `cita` (
  `idCita` int(11) NOT NULL,
  `idBarberoFk` int(11) DEFAULT NULL,
  `idClienteFk` int(11) DEFAULT NULL,
  `idServicioFk` int(11) DEFAULT NULL,
  `idAgendaFk` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `horaInicio` time DEFAULT NULL,
  `observaciones` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cita`
--

INSERT INTO `cita` (`idCita`, `idBarberoFk`, `idClienteFk`, `idServicioFk`, `idAgendaFk`, `fecha`, `horaInicio`, `observaciones`) VALUES
(1, 1, 1, 1, 1, '2026-03-20', '09:30:00', NULL),
(2, 2, 2, 3, 2, '2026-03-20', '11:00:00', NULL),
(3, 1, 3, 5, 3, '2026-03-21', '10:15:00', NULL),
(4, 2, 4, 2, 4, '2026-03-21', '15:30:00', NULL),
(5, 1, 5, 4, 5, '2026-03-22', '09:00:00', NULL),
(6, 2, 6, 1, 6, '2026-03-22', '12:00:00', NULL),
(7, 1, 7, 6, 7, '2026-03-23', '11:30:00', NULL),
(8, 2, 8, 7, 8, '2026-03-23', '12:00:00', NULL),
(9, 1, 9, 8, 9, '2026-03-24', '09:00:00', NULL),
(10, 2, 10, 9, 10, '2026-03-24', '10:00:00', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `idCliente` int(11) NOT NULL,
  `idUsuarioFk` int(11) DEFAULT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `fechaRegistro` date DEFAULT NULL,
  `contactoEmergencia` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`idCliente`, `idUsuarioFk`, `direccion`, `fechaRegistro`, `contactoEmergencia`) VALUES
(1, 4, 'Av. Amazonas', '2026-01-10', 'Maria-099'),
(2, 6, 'Calle Larga', '2026-01-12', 'Jose-098'),
(3, 7, 'Condado', '2026-01-15', 'Ana-097'),
(4, 8, 'La Floresta', '2026-01-20', 'Luis-096'),
(5, 9, 'Quitumbe', '2026-01-25', 'Rosa-095'),
(6, 10, 'Cumbayá', '2026-01-28', 'Felipe-094'),
(7, 4, 'Av. Amazonas', '2026-02-01', 'Elena-093'),
(8, 6, 'Calle Larga', '2026-02-05', 'Maria-099'),
(9, 7, 'Condado', '2026-02-10', 'Jose-098'),
(10, 8, 'La Floresta', '2026-02-15', 'Ana-097');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pago`
--

CREATE TABLE `pago` (
  `idPago` int(11) NOT NULL,
  `metodoPago` varchar(35) DEFAULT NULL,
  `montoTotal` decimal(10,2) DEFAULT NULL,
  `fechaPago` datetime DEFAULT NULL,
  `estadoPago` enum('PAGADO','PENDIENTE','CANCELADO') DEFAULT NULL,
  `codigoFactura` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pago`
--

INSERT INTO `pago` (`idPago`, `metodoPago`, `montoTotal`, `fechaPago`, `estadoPago`, `codigoFactura`) VALUES
(1, 'Efectivo', 13.00, '2026-04-07 07:20:00', 'PAGADO', 'FAC-001'),
(2, 'Visa', 18.00, '2026-04-07 07:20:00', 'PAGADO', 'FAC-002'),
(3, 'Transferencia', 14.00, '2026-04-07 07:20:00', 'PENDIENTE', 'FAC-003'),
(4, 'Efectivo', 8.00, '2026-04-07 07:20:00', 'CANCELADO', 'FAC-004'),
(5, 'MasterCard', 15.00, '2026-04-07 07:20:00', 'PAGADO', 'FAC-005'),
(6, 'Efectivo', 13.00, '2026-04-07 07:20:00', 'PAGADO', 'FAC-006'),
(7, 'Transferencia', 25.00, '2026-04-07 07:20:00', 'PENDIENTE', 'FAC-007'),
(8, 'Visa', 10.00, '2026-04-07 07:20:00', 'PAGADO', 'FAC-008'),
(9, 'Efectivo', 5.00, '2026-04-07 07:20:00', 'PAGADO', 'FAC-009'),
(10, 'Visa', 14.00, '2026-04-07 07:20:00', 'PAGADO', 'FAC-010');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `idRol` int(11) NOT NULL,
  `nombreRol` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`idRol`, `nombreRol`) VALUES
(1, 'Admin'),
(2, 'Barbero'),
(3, 'Cliente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicio`
--

CREATE TABLE `servicio` (
  `idServicio` int(11) NOT NULL,
  `nombreServicio` varchar(60) DEFAULT NULL,
  `duracion` int(11) DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `tipoServicio` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `servicio`
--

INSERT INTO `servicio` (`idServicio`, `nombreServicio`, `duracion`, `precio`, `tipoServicio`) VALUES
(1, 'Corte Tradicional', 35, 13.00, 'Cabello'),
(2, 'Perfilado Barba', 25, 8.00, 'Barba'),
(3, 'Combo', 60, 18.00, 'Combo'),
(4, 'Facial', 30, 15.00, 'Spa'),
(5, 'Fade', 45, 14.00, 'Cabello'),
(6, 'Tinte', 60, 25.00, 'Color'),
(7, 'Líneas', 15, 5.00, 'Arte'),
(8, 'Lavado', 10, 5.00, 'Cabello'),
(9, 'Cejas', 15, 4.00, 'Arte'),
(10, 'Mascarilla', 20, 10.00, 'Spa');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `idUsuario` int(11) NOT NULL,
  `cedula` varchar(15) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `correoUsuario` varchar(50) DEFAULT NULL,
  `numCelular` varchar(15) DEFAULT NULL,
  `contrasena` varchar(200) DEFAULT NULL,
  `fechaNacimiento` date DEFAULT NULL,
  `idRolFk` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`idUsuario`, `cedula`, `nombre`, `correoUsuario`, `numCelular`, `contrasena`, `fechaNacimiento`, `idRolFk`) VALUES
(1, '1723456789', 'ANDRÉS MENDOZA', 'a.mendoza@mya.com', '0998765432', NULL, NULL, 1),
(2, '1755842100', 'MATEO ALVEAR', 'mateo.barber@mya.com', '0984455667', NULL, NULL, 2),
(3, '1004556772', 'LUIS SIMBAÑA', 'luis.barber@mya.com', '0977889900', NULL, NULL, 2),
(4, '0503441288', 'CARLOS PÉREZ', 'carlitos@gmail.com', '0912233445', NULL, NULL, 3),
(5, '1711223344', 'JUAN RODRÍGUEZ', 'juan.rod@outlook.com', '0955667788', NULL, NULL, 3),
(6, '1204885991', 'ANA GARCÍA', 'ana.garcia@hotmail.com', '0966112233', NULL, NULL, 3),
(7, '0988776655', 'DIEGO FERNÁNDEZ', 'diego.fer@gmail.com', '0922446688', NULL, NULL, 3),
(8, '1788990011', 'ROBERTO GÓMEZ', 'roberto@gmail.com', '0933557799', NULL, NULL, 3),
(9, '1744556611', 'LUCÍA TORRES', 'lucia@gmail.com', '0944668800', NULL, NULL, 3),
(10, '1722334455', 'PEDRO SALAS', 'pedro@gmail.com', '0955779911', NULL, NULL, 3);

--
-- Disparadores `usuario`
--
DELIMITER $$
CREATE TRIGGER `AntesEliminarUsuario` BEFORE DELETE ON `usuario` FOR EACH ROW BEGIN
    IF OLD.idRolFk = 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar al Administrador principal';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `FormatearNombreUsuario` BEFORE INSERT ON `usuario` FOR EACH ROW BEGIN
    SET NEW.nombre = UPPER(NEW.nombre);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vistapagosexitosos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vistapagosexitosos` (
`codigoFactura` varchar(20)
,`metodoPago` varchar(35)
,`montoTotal` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vistaproximasagendas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vistaproximasagendas` (
`fecha` date
,`horaInicio` time
,`barbero` varchar(100)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vistarankingservicios`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vistarankingservicios` (
`nombreServicio` varchar(60)
,`vecesSolicitado` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vistapagosexitosos`
--
DROP TABLE IF EXISTS `vistapagosexitosos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vistapagosexitosos`  AS SELECT `pago`.`codigoFactura` AS `codigoFactura`, `pago`.`metodoPago` AS `metodoPago`, `pago`.`montoTotal` AS `montoTotal` FROM `pago` WHERE `pago`.`estadoPago` = 'PAGADO' ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vistaproximasagendas`
--
DROP TABLE IF EXISTS `vistaproximasagendas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vistaproximasagendas`  AS SELECT `a`.`fecha` AS `fecha`, `a`.`horaInicio` AS `horaInicio`, `u`.`nombre` AS `barbero` FROM ((`agenda` `a` join `barbero` `b` on(`a`.`idBarberoFk` = `b`.`idBarbero`)) join `usuario` `u` on(`b`.`idUsuarioFk` = `u`.`idUsuario`)) WHERE `a`.`fecha` >= curdate() ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vistarankingservicios`
--
DROP TABLE IF EXISTS `vistarankingservicios`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vistarankingservicios`  AS SELECT `s`.`nombreServicio` AS `nombreServicio`, count(`c`.`idCita`) AS `vecesSolicitado` FROM (`servicio` `s` left join `cita` `c` on(`s`.`idServicio` = `c`.`idServicioFk`)) GROUP BY `s`.`nombreServicio` ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `agenda`
--
ALTER TABLE `agenda`
  ADD PRIMARY KEY (`idAgenda`),
  ADD KEY `fk_agenda_barbero` (`idBarberoFk`);

--
-- Indices de la tabla `barbero`
--
ALTER TABLE `barbero`
  ADD PRIMARY KEY (`idBarbero`),
  ADD KEY `fk_barbero_usuario` (`idUsuarioFk`);

--
-- Indices de la tabla `cita`
--
ALTER TABLE `cita`
  ADD PRIMARY KEY (`idCita`),
  ADD KEY `idx_fecha_cita` (`fecha`),
  ADD KEY `fk_cita_barbero` (`idBarberoFk`),
  ADD KEY `fk_cita_cliente` (`idClienteFk`),
  ADD KEY `fk_cita_servicio` (`idServicioFk`),
  ADD KEY `fk_cita_agenda` (`idAgendaFk`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`idCliente`),
  ADD KEY `fk_cliente_usuario` (`idUsuarioFk`);

--
-- Indices de la tabla `pago`
--
ALTER TABLE `pago`
  ADD PRIMARY KEY (`idPago`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`idRol`);

--
-- Indices de la tabla `servicio`
--
ALTER TABLE `servicio`
  ADD PRIMARY KEY (`idServicio`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idUsuario`),
  ADD UNIQUE KEY `cedula` (`cedula`),
  ADD KEY `idx_correo_usuario` (`correoUsuario`),
  ADD KEY `fk_usuario_rol` (`idRolFk`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `agenda`
--
ALTER TABLE `agenda`
  MODIFY `idAgenda` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `barbero`
--
ALTER TABLE `barbero`
  MODIFY `idBarbero` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `cita`
--
ALTER TABLE `cita`
  MODIFY `idCita` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `idCliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `pago`
--
ALTER TABLE `pago`
  MODIFY `idPago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `idRol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `servicio`
--
ALTER TABLE `servicio`
  MODIFY `idServicio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idUsuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `agenda`
--
ALTER TABLE `agenda`
  ADD CONSTRAINT `fk_agenda_barbero` FOREIGN KEY (`idBarberoFk`) REFERENCES `barbero` (`idBarbero`);

--
-- Filtros para la tabla `barbero`
--
ALTER TABLE `barbero`
  ADD CONSTRAINT `fk_barbero_usuario` FOREIGN KEY (`idUsuarioFk`) REFERENCES `usuario` (`idUsuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `cita`
--
ALTER TABLE `cita`
  ADD CONSTRAINT `fk_cita_agenda` FOREIGN KEY (`idAgendaFk`) REFERENCES `agenda` (`idAgenda`),
  ADD CONSTRAINT `fk_cita_barbero` FOREIGN KEY (`idBarberoFk`) REFERENCES `barbero` (`idBarbero`),
  ADD CONSTRAINT `fk_cita_cliente` FOREIGN KEY (`idClienteFk`) REFERENCES `cliente` (`idCliente`),
  ADD CONSTRAINT `fk_cita_servicio` FOREIGN KEY (`idServicioFk`) REFERENCES `servicio` (`idServicio`);

--
-- Filtros para la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `fk_cliente_usuario` FOREIGN KEY (`idUsuarioFk`) REFERENCES `usuario` (`idUsuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_usuario_rol` FOREIGN KEY (`idRolFk`) REFERENCES `rol` (`idRol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
