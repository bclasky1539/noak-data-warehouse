/*
=============================================================
Create Database and Schemas
=============================================================
Overview
    This script establishes a fresh 'retail_data_warehouse' database by first removing any existing version.
    It then creates three organizational layers within the database: 'bronze', 'silver', and 'gold' schemas.
	
CAUTION:
    Executing this script will completely remove the existing 'retail_data_warehouse' database if one exists.
	This action is irreversible and will erase all contained data. Before proceeding, verify you have appropriate
	backups in place.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'retail_data_warehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create database retail_data_warehouse
CREATE DATABASE retail_data_warehouse;
GO

USE retail_data_warehouse;
GO

-- Create the schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO

