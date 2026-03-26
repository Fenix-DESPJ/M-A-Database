-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 26-03-2026 a las 16:35:21
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarPrecioServicio` (`p_id` INT, `p_nuevo_precio` DECIMAL(10,2))   BEGIN
    UPDATE servicio SET precio = p_nuevo_precio WHERE id_Servicio = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarTelefonoUsuario` (`p_id` INT, `p_nuevo_cel` VARCHAR(15))   BEGIN
    UPDATE Usuario SET Num_Celular = p_nuevo_cel WHERE Id_Usuario = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminarBarbero` (`p_id` INT)   BEGIN
    DELETE FROM barbero WHERE id_Barbero = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminarPagoPendiente` (`p_id` INT)   BEGIN
    DELETE FROM Pago WHERE iD_Pago = p_id AND estado_Pago = 'PENDIENTE';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `HistorialCitaPorCliente` (IN `p_id_cliente` INT)   BEGIN
    SELECT
        c.id_Cita,
        u.nombre AS Cliente,
        c.Fecha,
        c.hora_Inicio,
        s.nombre_Servicio,
        c.observaciones
    FROM cita c
    INNER JOIN cliente cl ON c.id_Cliente_fk = cl.id_Cliente
    INNER JOIN usuario u ON cl.id_Usuario_fk = u.Id_Usuario
    -- Corrección: Unir cita con servicio usando la FK correcta
    INNER JOIN servicio s ON c.id_Servicio_fk = s.id_Servicio 
    WHERE cl.id_Cliente = p_id_cliente
    ORDER BY c.Fecha DESC, c.hora_Inicio DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `HistorialCitasClientes` ()   BEGIN
    SELECT c.id_Cita, u.nombre AS Cliente, c.Fecha, c.hora_Inicio
    FROM cita c
    INNER JOIN cliente cl ON c.id_Cliente_fk = cl.id_Cliente
    INNER JOIN usuario u ON cl.id_Usuario_fk = u.Id_Usuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IngresosPorMetodo` ()   BEGIN
    SELECT metodo_Pago, SUM(monto_total) as Total 
    FROM Pago 
    WHERE estado_Pago = 'PAGADO'
    GROUP BY metodo_Pago;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarServicioExpress` (`p_nom` VARCHAR(60), `p_precio` DECIMAL(10,2))   BEGIN
    INSERT INTO Servicio (nombre_Servicio, duracion, precio, tipo_servicio) 
    VALUES (p_nom, 30, p_precio, 'Express');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ReporteEspecialidadesBarberos` ()   BEGIN
    SELECT u.nombre, b.especialidad 
    FROM usuario u
    INNER JOIN barbero b ON u.Id_Usuario = b.id_Usuario_fk;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `VerCitasHoy` ()   BEGIN
    SELECT C.id_Cita, U.nombre AS Nombre_Cliente, S.nombre_Servicio, C.hora_Inicio, B_U.nombre AS Nombre_Barbero
    FROM Cita C
    INNER JOIN Cliente Cl ON C.id_Cliente_fk = Cl.id_Cliente
    INNER JOIN Usuario U ON Cl.id_Usuario_fk = U.Id_Usuario
    INNER JOIN Servicio S ON C.id_Servicio_fk = S.id_Servicio
    INNER JOIN Barbero B ON C.id_barbero_fk = B.id_Barbero
    INNER JOIN Usuario B_U ON B.id_Usuario_fk = B_U.Id_Usuario;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `agenda`
--

CREATE TABLE `agenda` (
  `id_Agenda` int(11) NOT NULL,
  `id_Barbero_fk` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora_Inicio` time DEFAULT NULL,
  `hora_Fin` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `agenda`
--

INSERT INTO `agenda` (`id_Agenda`, `id_Barbero_fk`, `fecha`, `hora_Inicio`, `hora_Fin`) VALUES
(1, 1, '2026-03-20', '09:00:00', '13:00:00'),
(2, 2, '2026-03-20', '10:00:00', '14:00:00'),
(3, 1, '2026-03-21', '09:00:00', '13:00:00'),
(4, 2, '2026-03-21', '15:00:00', '19:00:00'),
(5, 1, '2026-03-22', '09:00:00', '13:00:00'),
(6, 2, '2026-03-22', '10:00:00', '14:00:00'),
(7, 1, '2026-03-23', '09:00:00', '13:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `barbero`
--

CREATE TABLE `barbero` (
  `id_Barbero` int(11) NOT NULL,
  `id_Usuario_fk` int(11) DEFAULT NULL,
  `especialidad` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `barbero`
--

INSERT INTO `barbero` (`id_Barbero`, `id_Usuario_fk`, `especialidad`) VALUES
(1, 2, 'Master Fade & Diseños'),
(2, 5, 'Barba Clásica y Toalla Caliente'),
(3, 2, 'Cortes Modernos'),
(4, 5, 'Corte con Tijera'),
(5, 2, 'Pigmentación'),
(6, 5, 'Tratamientos Capilares'),
(7, 2, 'Corte para Niños');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `barbero_servicio`
--

CREATE TABLE `barbero_servicio` (
  `id_Barbero_fk` int(11) NOT NULL,
  `id_Servicio_fk` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `barbero_servicio`
--

INSERT INTO `barbero_servicio` (`id_Barbero_fk`, `id_Servicio_fk`) VALUES
(1, 1),
(1, 3),
(1, 5),
(1, 7),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(3, 1),
(3, 7),
(4, 5),
(4, 6),
(5, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cita`
--

CREATE TABLE `cita` (
  `id_Cita` int(11) NOT NULL,
  `id_barbero_fk` int(11) DEFAULT NULL,
  `id_Cliente_fk` int(11) DEFAULT NULL,
  `id_Servicio_fk` int(11) DEFAULT NULL,
  `id_Agenda_fk` int(11) DEFAULT NULL,
  `Fecha` date DEFAULT NULL,
  `hora_Inicio` time DEFAULT NULL,
  `observaciones` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cita`
--

INSERT INTO `cita` (`id_Cita`, `id_barbero_fk`, `id_Cliente_fk`, `id_Servicio_fk`, `id_Agenda_fk`, `Fecha`, `hora_Inicio`, `observaciones`) VALUES
(1, 1, 1, 1, 1, '2026-03-20', '09:30:00', 'Cliente solicita acabado con navaja en la nuca'),
(2, 2, 2, 3, 2, '2026-03-20', '11:00:00', 'Combo completo: hidratación de barba incluida'),
(3, 1, 3, 5, 3, '2026-03-21', '10:15:00', 'Fade bajo (Low Fade) con caída natural'),
(4, 2, 4, 2, 4, '2026-03-21', '15:30:00', 'Corte de barba con volumen, no rebajar mucho el largo'),
(5, 1, 1, 4, 5, '2026-03-22', '09:00:00', 'Cliente con piel sensible, usar productos hipoalergénicos'),
(6, 2, 2, 1, 6, '2026-03-22', '12:00:00', 'Cliente solicita acabado con navaja en la nuca'),
(7, 1, 3, 6, 7, '2026-03-23', '11:30:00', 'Aplicar tinte negro natural, cubrir canas al 100%');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `id_Cliente` int(11) NOT NULL,
  `id_Usuario_fk` int(11) DEFAULT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `fecha_Registro` date DEFAULT NULL,
  `contacto_emergencia` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`id_Cliente`, `id_Usuario_fk`, `direccion`, `fecha_Registro`, `contacto_emergencia`) VALUES
(1, 3, 'Av. de los Granados N34-12', '2026-01-10', 'María López - 0998877665'),
(2, 4, 'Calle Larga y Huayna Cápac', '2026-01-12', 'José Rodríguez - 0987766554'),
(3, 6, 'Urbanización El Condado', '2026-01-15', 'Ana García - 0976655443'),
(4, 7, 'Sector La Floresta, Calle B', '2026-01-20', 'Luis Fernández - 0965544332'),
(5, 3, 'Av. de los Granados N34-12', '2026-02-01', 'Carmen Mendoza - 0954433221'),
(6, 4, 'Calle Larga y Huayna Cápac', '2026-02-05', 'Pedro Alvear - 0943322110'),
(7, 6, 'Urbanización El Condado', '2026-02-10', 'Elena Simbaña - 0932211009');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pago`
--

CREATE TABLE `pago` (
  `iD_Pago` int(11) NOT NULL,
  `metodo_Pago` varchar(35) DEFAULT NULL,
  `monto_total` int(8) DEFAULT NULL,
  `fecha_Pago` datetime DEFAULT NULL,
  `estado_Pago` enum('PAGADO','PENDIENTE','CANCELADO') DEFAULT NULL,
  `referencia_pago` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pago`
--

INSERT INTO `pago` (`iD_Pago`, `metodo_Pago`, `monto_total`, `fecha_Pago`, `estado_Pago`, `referencia_pago`) VALUES
(1, 'Efectivo', 13, '2026-03-16 09:44:01', 'PAGADO', 'FAC-001'),
(2, 'Tarjeta Visa', 18, '2026-03-16 09:44:01', 'PAGADO', 'FAC-002'),
(3, 'Transferencia', 14, '2026-03-16 09:44:01', 'PENDIENTE', 'FAC-003'),
(4, 'Efectivo', 8, '2026-03-16 09:44:01', 'CANCELADO', 'FAC-004'),
(5, 'Tarjeta Master', 15, '2026-03-16 09:44:01', 'PAGADO', 'FAC-005'),
(6, 'Efectivo', 13, '2026-03-16 09:44:01', 'PAGADO', 'FAC-006'),
(7, 'Transferencia', 25, '2026-03-16 09:44:01', 'PENDIENTE', 'FAC-007');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pago_por_servicio`
--

CREATE TABLE `pago_por_servicio` (
  `id_Pago` int(11) NOT NULL,
  `id_Servicio` int(11) NOT NULL,
  `cantidad` int(11) DEFAULT 1,
  `precio_Fijo` int(8) DEFAULT NULL,
  `valor_Servicio` int(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pago_por_servicio`
--

INSERT INTO `pago_por_servicio` (`id_Pago`, `id_Servicio`, `cantidad`, `precio_Fijo`, `valor_Servicio`) VALUES
(1, 1, 1, 13, 13),
(2, 3, 1, 18, 18),
(3, 5, 1, 14, 14),
(4, 2, 1, 8, 8),
(5, 4, 1, 15, 15),
(6, 1, 1, 13, 13),
(7, 6, 1, 25, 25);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `id_Rol` int(11) NOT NULL,
  `nombre_Rol` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`id_Rol`, `nombre_Rol`) VALUES
(1, 'Admin'),
(2, 'Barbero'),
(3, 'Cliente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicio`
--

CREATE TABLE `servicio` (
  `id_Servicio` int(11) NOT NULL,
  `nombre_Servicio` varchar(60) DEFAULT NULL,
  `duracion` int(11) DEFAULT NULL,
  `precio` int(8) DEFAULT NULL,
  `tipo_servicio` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `servicio`
--

INSERT INTO `servicio` (`id_Servicio`, `nombre_Servicio`, `duracion`, `precio`, `tipo_servicio`) VALUES
(1, 'Corte Tradicional', 35, 13, 'Cabello'),
(2, 'Perfilado de Barba', 25, 8, 'Barba'),
(3, 'Corte + Barba (Combo)', 1, 18, 'Combo'),
(4, 'Limpieza Facial', 30, 15, 'Spa'),
(5, 'Corte Degradado (Fade)', 45, 14, 'Cabello'),
(6, 'Tinte de Cabello', 1, 25, 'Color'),
(7, 'Diseño de Líneas', 15, 5, 'Arte');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `Id_Usuario` int(11) NOT NULL,
  `cedula` varchar(15) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `correo_Usuario` varchar(50) DEFAULT NULL,
  `Num_Celular` varchar(15) DEFAULT NULL,
  `contrasena` varchar(200) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `id_Rol_fk` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`Id_Usuario`, `cedula`, `nombre`, `correo_Usuario`, `Num_Celular`, `contrasena`, `fecha_nacimiento`, `id_Rol_fk`) VALUES
(1, '1723456789', 'Andrés Mendoza', 'a.mendoza@mya.com', '0998765432', 'hash_admin_123', NULL, 1),
(2, '1755842100', 'Mateo Alvear', 'mateo.barber@mya.com', '0984455667', 'hash_mateo_321', NULL, 2),
(3, '0503441288', 'Carlos Pérez', 'carlitos_99@gmail.com', '0912233445', 'pass_carlos', NULL, 3),
(4, '1711223344', 'Juan Rodríguez', 'juan.rod@outlook.com', '0955667788', 'pass_juan', NULL, 3),
(5, '1004556772', 'Luis Simbaña', 'luis.barber@mya.com', '0977889900', 'hash_luis_44', NULL, 2),
(6, '1204885991', 'Ana García', 'ana.garcia@hotmail.com', '0966112233', 'pass_ana', NULL, 3),
(7, '0988776655', 'Diego Fernández', 'diego.fer@gmail.com', '0922446688', 'pass_diego', NULL, 3);

--
-- Disparadores `usuario`
--
DELIMITER $$
CREATE TRIGGER `AntesEliminarUsuario` BEFORE DELETE ON `usuario` FOR EACH ROW BEGIN
    IF OLD.id_Rol_fk = 1 THEN
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
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vistaproximasagendas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vistaproximasagendas` (
`fecha` date
,`hora_Inicio` time
,`Barbero` varchar(100)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vistarankingservicios`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vistarankingservicios` (
`nombre_Servicio` varchar(60)
,`Veces_Solicitado` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_info_servicios`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_info_servicios` (
`nombre_Servicio` varchar(60)
,`duracion_detallada` varchar(15)
,`precio` int(8)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vistapagosexitosos`
--
DROP TABLE IF EXISTS `vistapagosexitosos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vistapagosexitosos`  AS SELECT `pago`.`codigo_Factura` AS `codigo_Factura`, `pago`.`metodo_Pago` AS `metodo_Pago`, `pago`.`monto_total` AS `monto_total` FROM `pago` WHERE `pago`.`estado_Pago` = 'PAGADO' ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vistaproximasagendas`
--
DROP TABLE IF EXISTS `vistaproximasagendas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vistaproximasagendas`  AS SELECT `a`.`fecha` AS `fecha`, `a`.`hora_Inicio` AS `hora_Inicio`, `u`.`nombre` AS `Barbero` FROM ((`agenda` `a` join `barbero` `b` on(`a`.`id_Barbero_fk` = `b`.`id_Barbero`)) join `usuario` `u` on(`b`.`id_Usuario_fk` = `u`.`Id_Usuario`)) WHERE `a`.`fecha` >= curdate() ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vistarankingservicios`
--
DROP TABLE IF EXISTS `vistarankingservicios`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vistarankingservicios`  AS SELECT `s`.`nombre_Servicio` AS `nombre_Servicio`, count(`c`.`id_Cita`) AS `Veces_Solicitado` FROM (`servicio` `s` left join `cita` `c` on(`s`.`id_Servicio` = `c`.`id_Servicio_fk`)) GROUP BY `s`.`nombre_Servicio` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_info_servicios`
--
DROP TABLE IF EXISTS `vista_info_servicios`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_info_servicios`  AS SELECT `servicio`.`nombre_Servicio` AS `nombre_Servicio`, CASE WHEN `servicio`.`duracion` = '1' THEN '1 hora' WHEN `servicio`.`duracion` = '1h' THEN '1 hora' ELSE concat(`servicio`.`duracion`,' min') END AS `duracion_detallada`, `servicio`.`precio` AS `precio` FROM `servicio` ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `agenda`
--
ALTER TABLE `agenda`
  ADD PRIMARY KEY (`id_Agenda`),
  ADD KEY `id_Barbero_fk` (`id_Barbero_fk`);

--
-- Indices de la tabla `barbero`
--
ALTER TABLE `barbero`
  ADD PRIMARY KEY (`id_Barbero`),
  ADD KEY `id_Usuario_fk` (`id_Usuario_fk`);

--
-- Indices de la tabla `barbero_servicio`
--
ALTER TABLE `barbero_servicio`
  ADD PRIMARY KEY (`id_Barbero_fk`,`id_Servicio_fk`),
  ADD KEY `id_Servicio_fk` (`id_Servicio_fk`);

--
-- Indices de la tabla `cita`
--
ALTER TABLE `cita`
  ADD PRIMARY KEY (`id_Cita`),
  ADD KEY `id_barbero_fk` (`id_barbero_fk`),
  ADD KEY `id_Cliente_fk` (`id_Cliente_fk`),
  ADD KEY `id_Servicio_fk` (`id_Servicio_fk`),
  ADD KEY `id_Agenda_fk` (`id_Agenda_fk`),
  ADD KEY `idx_fecha_cita` (`Fecha`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`id_Cliente`),
  ADD KEY `id_Usuario_fk` (`id_Usuario_fk`);

--
-- Indices de la tabla `pago`
--
ALTER TABLE `pago`
  ADD PRIMARY KEY (`iD_Pago`);

--
-- Indices de la tabla `pago_por_servicio`
--
ALTER TABLE `pago_por_servicio`
  ADD PRIMARY KEY (`id_Pago`,`id_Servicio`),
  ADD KEY `id_Servicio` (`id_Servicio`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id_Rol`);

--
-- Indices de la tabla `servicio`
--
ALTER TABLE `servicio`
  ADD PRIMARY KEY (`id_Servicio`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`Id_Usuario`),
  ADD UNIQUE KEY `cedula` (`cedula`),
  ADD KEY `id_Rol_fk` (`id_Rol_fk`),
  ADD KEY `idx_correo_usuario` (`correo_Usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `agenda`
--
ALTER TABLE `agenda`
  MODIFY `id_Agenda` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `barbero`
--
ALTER TABLE `barbero`
  MODIFY `id_Barbero` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `cita`
--
ALTER TABLE `cita`
  MODIFY `id_Cita` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `id_Cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `pago`
--
ALTER TABLE `pago`
  MODIFY `iD_Pago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `id_Rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `servicio`
--
ALTER TABLE `servicio`
  MODIFY `id_Servicio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `Id_Usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `agenda`
--
ALTER TABLE `agenda`
  ADD CONSTRAINT `agenda_ibfk_1` FOREIGN KEY (`id_Barbero_fk`) REFERENCES `barbero` (`id_Barbero`);

--
-- Filtros para la tabla `barbero`
--
ALTER TABLE `barbero`
  ADD CONSTRAINT `barbero_ibfk_1` FOREIGN KEY (`id_Usuario_fk`) REFERENCES `usuario` (`Id_Usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `barbero_servicio`
--
ALTER TABLE `barbero_servicio`
  ADD CONSTRAINT `barbero_servicio_ibfk_1` FOREIGN KEY (`id_Barbero_fk`) REFERENCES `barbero` (`id_Barbero`) ON DELETE CASCADE,
  ADD CONSTRAINT `barbero_servicio_ibfk_2` FOREIGN KEY (`id_Servicio_fk`) REFERENCES `servicio` (`id_Servicio`) ON DELETE CASCADE;

--
-- Filtros para la tabla `cita`
--
ALTER TABLE `cita`
  ADD CONSTRAINT `cita_ibfk_1` FOREIGN KEY (`id_barbero_fk`) REFERENCES `barbero` (`id_Barbero`),
  ADD CONSTRAINT `cita_ibfk_2` FOREIGN KEY (`id_Cliente_fk`) REFERENCES `cliente` (`id_Cliente`),
  ADD CONSTRAINT `cita_ibfk_3` FOREIGN KEY (`id_Servicio_fk`) REFERENCES `servicio` (`id_Servicio`),
  ADD CONSTRAINT `cita_ibfk_4` FOREIGN KEY (`id_Agenda_fk`) REFERENCES `agenda` (`id_Agenda`);

--
-- Filtros para la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `cliente_ibfk_1` FOREIGN KEY (`id_Usuario_fk`) REFERENCES `usuario` (`Id_Usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `pago_por_servicio`
--
ALTER TABLE `pago_por_servicio`
  ADD CONSTRAINT `pago_por_servicio_ibfk_1` FOREIGN KEY (`id_Pago`) REFERENCES `pago` (`iD_Pago`) ON DELETE CASCADE,
  ADD CONSTRAINT `pago_por_servicio_ibfk_2` FOREIGN KEY (`id_Servicio`) REFERENCES `servicio` (`id_Servicio`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`id_Rol_fk`) REFERENCES `rol` (`id_Rol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
