-- This script deletes the database 'NovaInsights' if it exists and then recreates it. Otherwise it creates the database.
-- This script sets up the bronze, silver and gold schemas

USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'NovaInsights')
BEGIN
	ALTER DATABASE NovaInsights SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE NovaInsights;
END;
GO

CREATE DATABASE NovaInsights;
GO

USE NovaInsights;
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO