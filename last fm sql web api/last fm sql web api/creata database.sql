USE [master]
GO

/****** Object:  Database [lastfm]    Script Date: 31.07.2020 16:27:33 ******/
CREATE DATABASE [lastfm]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'lastfm', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQL\MSSQL\DATA\lastfm.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'lastfm_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQL\MSSQL\DATA\lastfm_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [lastfm].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [lastfm] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [lastfm] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [lastfm] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [lastfm] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [lastfm] SET ARITHABORT OFF 
GO

ALTER DATABASE [lastfm] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [lastfm] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [lastfm] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [lastfm] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [lastfm] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [lastfm] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [lastfm] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [lastfm] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [lastfm] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [lastfm] SET  DISABLE_BROKER 
GO

ALTER DATABASE [lastfm] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [lastfm] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [lastfm] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [lastfm] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [lastfm] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [lastfm] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [lastfm] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [lastfm] SET RECOVERY SIMPLE 
GO

ALTER DATABASE [lastfm] SET  MULTI_USER 
GO

ALTER DATABASE [lastfm] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [lastfm] SET DB_CHAINING OFF 
GO

ALTER DATABASE [lastfm] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [lastfm] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [lastfm] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [lastfm] SET QUERY_STORE = OFF
GO

ALTER DATABASE [lastfm] SET  READ_WRITE 
GO

