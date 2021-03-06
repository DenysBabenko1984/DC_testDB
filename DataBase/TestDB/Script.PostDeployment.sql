﻿/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

--Insert static data 
:r .\_StaticScripts\RequestStatus.sql
:r .\_StaticScripts\AttributeTypes.sql



-- Last step.  Apply security
:r .\Security\ApplySecurityModel.sql