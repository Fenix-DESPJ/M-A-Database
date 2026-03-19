-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 19, 2026 at 12:17 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `barbershop_m&a`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarTelefonoUsuario` (`p_id` INT, `p_nuevo_cel` VARCHAR(15))   BEGIN
    UPDATE Usuario SET Num_Celular = p_nuevo_cel WHERE Id_Usuario = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminarPagoPendiente` (`p_id` INT)   BEGIN
    DELETE FROM Pago WHERE iD_Pago = p_id AND estado_Pago = 'PENDIENTE';
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
-- Table structure for table `agenda`
--

CREATE TABLE `agenda` (
  `id_Agenda` int(11) NOT NULL,
  `id_Barbero_fk` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora_Inicio` time DEFAULT NULL,
  `hora_Fin` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `agenda`
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
-- Table structure for table `barbero`
--

CREATE TABLE `barbero` (
  `id_Barbero` int(11) NOT NULL,
  `id_Usuario_fk` int(11) DEFAULT NULL,
  `especialidad` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `barbero`
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
-- Table structure for table `barbero_servicio`
--

CREATE TABLE `barbero_servicio` (
  `id_Barbero_fk` int(11) NOT NULL,
  `id_Servicio_fk` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `barbero_servicio`
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
-- Table structure for table `cita`
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
-- Dumping data for table `cita`
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
-- Table structure for table `cliente`
--

CREATE TABLE `cliente` (
  `id_Cliente` int(11) NOT NULL,
  `id_Usuario_fk` int(11) DEFAULT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `fecha_Registro` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cliente`
--

INSERT INTO `cliente` (`id_Cliente`, `id_Usuario_fk`, `direccion`, `fecha_Registro`) VALUES
(1, 3, 'Av. de los Granados N34-12', '2026-01-10'),
(2, 4, 'Calle Larga y Huayna Cápac', '2026-01-12'),
(3, 6, 'Urbanización El Condado', '2026-01-15'),
(4, 7, 'Sector La Floresta, Calle B', '2026-01-20'),
(5, 3, 'Av. de los Granados N34-12', '2026-02-01'),
(6, 4, 'Calle Larga y Huayna Cápac', '2026-02-05'),
(7, 6, 'Urbanización El Condado', '2026-02-10');

-- --------------------------------------------------------

--
-- Table structure for table `pago`
--

CREATE TABLE `pago` (
  `iD_Pago` int(11) NOT NULL,
  `metodo_Pago` varchar(35) DEFAULT NULL,
  `monto_total` decimal(10,2) DEFAULT NULL,
  `fecha_Pago` datetime DEFAULT NULL,
  `estado_Pago` enum('PAGADO','PENDIENTE','CANCELADO') DEFAULT NULL,
  `codigo_Factura` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pago`
--

INSERT INTO `pago` (`iD_Pago`, `metodo_Pago`, `monto_total`, `fecha_Pago`, `estado_Pago`, `codigo_Factura`) VALUES
(1, 'Efectivo', 12.50, '2026-03-16 09:44:01', 'PAGADO', 'FAC-001'),
(2, 'Tarjeta Visa', 18.00, '2026-03-16 09:44:01', 'PAGADO', 'FAC-002'),
(3, 'Transferencia', 14.00, '2026-03-16 09:44:01', 'PENDIENTE', 'FAC-003'),
(4, 'Efectivo', 8.00, '2026-03-16 09:44:01', 'CANCELADO', 'FAC-004'),
(5, 'Tarjeta Master', 15.00, '2026-03-16 09:44:01', 'PAGADO', 'FAC-005'),
(6, 'Efectivo', 12.50, '2026-03-16 09:44:01', 'PAGADO', 'FAC-006'),
(7, 'Transferencia', 25.00, '2026-03-16 09:44:01', 'PENDIENTE', 'FAC-007');

-- --------------------------------------------------------

--
-- Table structure for table `pago_por_servicio`
--

CREATE TABLE `pago_por_servicio` (
  `id_Pago` int(11) NOT NULL,
  `id_Servicio` int(11) NOT NULL,
  `cantidad` int(11) DEFAULT 1,
  `precio_Fijo` decimal(10,2) DEFAULT NULL,
  `valor_Servicio` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pago_por_servicio`
--

INSERT INTO `pago_por_servicio` (`id_Pago`, `id_Servicio`, `cantidad`, `precio_Fijo`, `valor_Servicio`) VALUES
(1, 1, 1, 12.50, 12.50),
(2, 3, 1, 18.00, 18.00),
(3, 5, 1, 14.00, 14.00),
(4, 2, 1, 8.00, 8.00),
(5, 4, 1, 15.00, 15.00),
(6, 1, 1, 12.50, 12.50),
(7, 6, 1, 25.00, 25.00);

-- --------------------------------------------------------

--
-- Table structure for table `rol`
--

CREATE TABLE `rol` (
  `id_Rol` int(11) NOT NULL,
  `nombre_Rol` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rol`
--

INSERT INTO `rol` (`id_Rol`, `nombre_Rol`) VALUES
(1, 'Admin'),
(2, 'Barbero'),
(3, 'Cliente');

-- --------------------------------------------------------

--
-- Table structure for table `servicio`
--

CREATE TABLE `servicio` (
  `id_Servicio` int(11) NOT NULL,
  `nombre_Servicio` varchar(60) DEFAULT NULL,
  `duracion` int(11) DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `tipo_servicio` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `servicio`
--

INSERT INTO `servicio` (`id_Servicio`, `nombre_Servicio`, `duracion`, `precio`, `tipo_servicio`) VALUES
(1, 'Corte Tradicional', 35, 12.50, 'Cabello'),
(2, 'Perfilado de Barba', 25, 8.00, 'Barba'),
(3, 'Corte + Barba (Combo)', 1, 18.00, 'Combo'),
(4, 'Limpieza Facial', 30, 15.00, 'Spa'),
(5, 'Corte Degradado (Fade)', 45, 14.00, 'Cabello'),
(6, 'Tinte de Cabello', 1, 25.00, 'Color'),
(7, 'Diseño de Líneas', 15, 5.00, 'Arte');

-- --------------------------------------------------------

--
-- Table structure for table `usuario`
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
-- Dumping data for table `usuario`
--

INSERT INTO `usuario` (`Id_Usuario`, `cedula`, `nombre`, `correo_Usuario`, `Num_Celular`, `contrasena`, `fecha_nacimiento`, `id_Rol_fk`) VALUES
(1, '1723456789', 'Andrés Mendoza', 'a.mendoza@mya.com', '0998765432', 'hash_admin_123', NULL, 1),
(2, '1755842100', 'Mateo Alvear', 'mateo.barber@mya.com', '0984455667', 'hash_mateo_321', NULL, 2),
(3, '0503441288', 'Carlos Pérez', 'carlitos_99@gmail.com', '0912233445', 'pass_carlos', NULL, 3),
(4, '1711223344', 'Juan Rodríguez', 'juan.rod@outlook.com', '0955667788', 'pass_juan', NULL, 3),
(5, '1004556772', 'Luis Simbaña', 'luis.barber@mya.com', '0977889900', 'hash_luis_44', NULL, 2),
(6, '1204885991', 'Ana García', 'ana.garcia@hotmail.com', '0966112233', 'pass_ana', NULL, 3),
(7, '0988776655', 'Diego Fernández', 'diego.fer@gmail.com', '0922446688', 'pass_diego', NULL, 3);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vistaproximasagendas`
-- (See below for the actual view)
--
CREATE TABLE `vistaproximasagendas` (
`fecha` date
,`hora_Inicio` time
,`Barbero` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vistarankingservicios`
-- (See below for the actual view)
--
CREATE TABLE `vistarankingservicios` (
`nombre_Servicio` varchar(60)
,`Veces_Solicitado` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vista_info_servicios`
-- (See below for the actual view)
--
CREATE TABLE `vista_info_servicios` (
`nombre_Servicio` varchar(60)
,`duracion_detallada` varchar(15)
,`precio` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Structure for view `vistaproximasagendas`
--
DROP TABLE IF EXISTS `vistaproximasagendas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vistaproximasagendas`  AS SELECT `a`.`fecha` AS `fecha`, `a`.`hora_Inicio` AS `hora_Inicio`, `u`.`nombre` AS `Barbero` FROM ((`agenda` `a` join `barbero` `b` on(`a`.`id_Barbero_fk` = `b`.`id_Barbero`)) join `usuario` `u` on(`b`.`id_Usuario_fk` = `u`.`Id_Usuario`)) WHERE `a`.`fecha` >= curdate() ;

-- --------------------------------------------------------

--
-- Structure for view `vistarankingservicios`
--
DROP TABLE IF EXISTS `vistarankingservicios`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vistarankingservicios`  AS SELECT `s`.`nombre_Servicio` AS `nombre_Servicio`, count(`c`.`id_Cita`) AS `Veces_Solicitado` FROM (`servicio` `s` left join `cita` `c` on(`s`.`id_Servicio` = `c`.`id_Servicio_fk`)) GROUP BY `s`.`nombre_Servicio` ;

-- --------------------------------------------------------

--
-- Structure for view `vista_info_servicios`
--
DROP TABLE IF EXISTS `vista_info_servicios`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_info_servicios`  AS SELECT `servicio`.`nombre_Servicio` AS `nombre_Servicio`, CASE WHEN `servicio`.`duracion` = '1' THEN '1 hora' WHEN `servicio`.`duracion` = '1h' THEN '1 hora' ELSE concat(`servicio`.`duracion`,' min') END AS `duracion_detallada`, `servicio`.`precio` AS `precio` FROM `servicio` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `agenda`
--
ALTER TABLE `agenda`
  ADD PRIMARY KEY (`id_Agenda`),
  ADD KEY `id_Barbero_fk` (`id_Barbero_fk`);

--
-- Indexes for table `barbero`
--
ALTER TABLE `barbero`
  ADD PRIMARY KEY (`id_Barbero`),
  ADD KEY `id_Usuario_fk` (`id_Usuario_fk`);

--
-- Indexes for table `barbero_servicio`
--
ALTER TABLE `barbero_servicio`
  ADD PRIMARY KEY (`id_Barbero_fk`,`id_Servicio_fk`),
  ADD KEY `id_Servicio_fk` (`id_Servicio_fk`);

--
-- Indexes for table `cita`
--
ALTER TABLE `cita`
  ADD PRIMARY KEY (`id_Cita`),
  ADD KEY `id_barbero_fk` (`id_barbero_fk`),
  ADD KEY `id_Cliente_fk` (`id_Cliente_fk`),
  ADD KEY `id_Servicio_fk` (`id_Servicio_fk`),
  ADD KEY `id_Agenda_fk` (`id_Agenda_fk`);

--
-- Indexes for table `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`id_Cliente`),
  ADD KEY `id_Usuario_fk` (`id_Usuario_fk`);

--
-- Indexes for table `pago`
--
ALTER TABLE `pago`
  ADD PRIMARY KEY (`iD_Pago`);

--
-- Indexes for table `pago_por_servicio`
--
ALTER TABLE `pago_por_servicio`
  ADD PRIMARY KEY (`id_Pago`,`id_Servicio`),
  ADD KEY `id_Servicio` (`id_Servicio`);

--
-- Indexes for table `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id_Rol`);

--
-- Indexes for table `servicio`
--
ALTER TABLE `servicio`
  ADD PRIMARY KEY (`id_Servicio`);

--
-- Indexes for table `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`Id_Usuario`),
  ADD UNIQUE KEY `cedula` (`cedula`),
  ADD KEY `id_Rol_fk` (`id_Rol_fk`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `agenda`
--
ALTER TABLE `agenda`
  MODIFY `id_Agenda` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `barbero`
--
ALTER TABLE `barbero`
  MODIFY `id_Barbero` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `cita`
--
ALTER TABLE `cita`
  MODIFY `id_Cita` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `cliente`
--
ALTER TABLE `cliente`
  MODIFY `id_Cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `pago`
--
ALTER TABLE `pago`
  MODIFY `iD_Pago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `rol`
--
ALTER TABLE `rol`
  MODIFY `id_Rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `servicio`
--
ALTER TABLE `servicio`
  MODIFY `id_Servicio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `usuario`
--
ALTER TABLE `usuario`
  MODIFY `Id_Usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `agenda`
--
ALTER TABLE `agenda`
  ADD CONSTRAINT `agenda_ibfk_1` FOREIGN KEY (`id_Barbero_fk`) REFERENCES `barbero` (`id_Barbero`);

--
-- Constraints for table `barbero`
--
ALTER TABLE `barbero`
  ADD CONSTRAINT `barbero_ibfk_1` FOREIGN KEY (`id_Usuario_fk`) REFERENCES `usuario` (`Id_Usuario`) ON DELETE CASCADE;

--
-- Constraints for table `barbero_servicio`
--
ALTER TABLE `barbero_servicio`
  ADD CONSTRAINT `barbero_servicio_ibfk_1` FOREIGN KEY (`id_Barbero_fk`) REFERENCES `barbero` (`id_Barbero`) ON DELETE CASCADE,
  ADD CONSTRAINT `barbero_servicio_ibfk_2` FOREIGN KEY (`id_Servicio_fk`) REFERENCES `servicio` (`id_Servicio`) ON DELETE CASCADE;

--
-- Constraints for table `cita`
--
ALTER TABLE `cita`
  ADD CONSTRAINT `cita_ibfk_1` FOREIGN KEY (`id_barbero_fk`) REFERENCES `barbero` (`id_Barbero`),
  ADD CONSTRAINT `cita_ibfk_2` FOREIGN KEY (`id_Cliente_fk`) REFERENCES `cliente` (`id_Cliente`),
  ADD CONSTRAINT `cita_ibfk_3` FOREIGN KEY (`id_Servicio_fk`) REFERENCES `servicio` (`id_Servicio`),
  ADD CONSTRAINT `cita_ibfk_4` FOREIGN KEY (`id_Agenda_fk`) REFERENCES `agenda` (`id_Agenda`);

--
-- Constraints for table `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `cliente_ibfk_1` FOREIGN KEY (`id_Usuario_fk`) REFERENCES `usuario` (`Id_Usuario`) ON DELETE CASCADE;

--
-- Constraints for table `pago_por_servicio`
--
ALTER TABLE `pago_por_servicio`
  ADD CONSTRAINT `pago_por_servicio_ibfk_1` FOREIGN KEY (`id_Pago`) REFERENCES `pago` (`iD_Pago`) ON DELETE CASCADE,
  ADD CONSTRAINT `pago_por_servicio_ibfk_2` FOREIGN KEY (`id_Servicio`) REFERENCES `servicio` (`id_Servicio`);

--
-- Constraints for table `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`id_Rol_fk`) REFERENCES `rol` (`id_Rol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
