-- ----------------------------------------------------------------------------
-- MySQL Workbench Migration
-- Migrated Schemata: Comics
-- Source Schemata: Comics
-- Created: Sun May 17 18:23:17 2020
-- Workbench Version: 8.0.20
-- ----------------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------------------------
-- Schema Comics
-- ----------------------------------------------------------------------------
DROP SCHEMA IF EXISTS `Comics` ;
CREATE SCHEMA IF NOT EXISTS `Comics` ;

-- ----------------------------------------------------------------------------
-- Table Comics.Files
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Comics`.`Files` (
  `FileID` INT NOT NULL,
  `FileBytes` LONGBLOB NOT NULL);

-- ----------------------------------------------------------------------------
-- Table Comics.sysdiagrams
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Comics`.`sysdiagrams` (
  `name` VARCHAR(160) NOT NULL,
  `principal_id` INT NOT NULL,
  `diagram_id` INT NOT NULL,
  `version` INT NULL,
  `definition` LONGBLOB NULL,
  PRIMARY KEY (`diagram_id`),
  UNIQUE INDEX `UK_principal_name` (`principal_id` ASC, `name` ASC) VISIBLE);

-- ----------------------------------------------------------------------------
-- Table Comics.SystemSettings
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Comics`.`SystemSettings` (
  `SystemSettingKey` VARCHAR(255) NOT NULL,
  `Value` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`SystemSettingKey`));

-- ----------------------------------------------------------------------------
-- Table Comics.StoryArcs
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Comics`.`StoryArcs` (
  `StoryArcID` INT NOT NULL,
  `StoryLineID` INT NOT NULL,
  `StoryArcName` VARCHAR(255) NOT NULL,
  `IsUnnamed` TINYINT(1) NOT NULL DEFAULT 0,
  `LastQuickPickDate` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE_CURRENT_TIMESTAMP,
  `CreationDate` DATE NULL,
  `ModificationDate` DATE NULL,
  PRIMARY KEY (`StoryArcID`),
  UNIQUE INDEX `UQ_StoryArcs_StoryLine_StoryArcName` (`StoryLineID` ASC, `StoryArcName` ASC) VISIBLE,
  CONSTRAINT `FK_StoryArcs_StoryLines`
    FOREIGN KEY (`StoryLineID`)
    REFERENCES `Comics`.`StoryLines` (`StoryLineID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Comics.Images
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Comics`.`Images` (
  `ImageID` INT NOT NULL,
  `ImageData` LONGBLOB NOT NULL,
  PRIMARY KEY (`ImageID`));

-- ----------------------------------------------------------------------------
-- Table Comics.PageImages
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Comics`.`PageImages` (
  `PageImageID` INT NOT NULL,
  `PageID` INT NOT NULL,
  `ImageID` INT NOT NULL,
  `ImageBytes` LONGBLOB NOT NULL,
  PRIMARY KEY (`PageImageID`),
  CONSTRAINT `FK_PageImages_Images`
    FOREIGN KEY (`ImageID`)
    REFERENCES `Comics`.`Images` (`ImageID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_PageImages_Pages`
    FOREIGN KEY (`PageID`)
    REFERENCES `Comics`.`Pages` (`PageID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Comics.LibraryFolders
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Comics`.`LibraryFolders` (
  `LibraryFolderID` INT NOT NULL,
  `LibraryFolderPath` VARCHAR(255) NOT NULL,
  `LibraryFolderDescription` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`LibraryFolderID`));

-- ----------------------------------------------------------------------------
-- Table Comics.Issues
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Comics`.`Issues` (
  `IssueID` INT NOT NULL,
  `SeriesID` INT NOT NULL,
  `IssueNumber` DECIMAL(18,4) NOT NULL,
  `FilePath` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`IssueID`),
  UNIQUE INDEX `UQ_Issues_SeriesID_IssueNumber` (`SeriesID` ASC, `IssueNumber` ASC) VISIBLE,
  UNIQUE INDEX `UQ_Issues_FilePath` (`IssueID` ASC) VISIBLE,
  INDEX `NonClusteredIndex-20190922-090903` (`IssueNumber` ASC) VISIBLE,
  CONSTRAINT `FK_Issues_Series`
    FOREIGN KEY (`SeriesID`)
    REFERENCES `Comics`.`Series` (`SeriesID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Comics.StoryLines
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Comics`.`StoryLines` (
  `StoryLineID` INT NOT NULL,
  `StoryLineName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`StoryLineID`),
  UNIQUE INDEX `UQ_StoryLines_StoryLineName` (`StoryLineName` ASC) VISIBLE,
  INDEX `NonClusteredIndex-20190922-092610` (`StoryLineName` ASC) VISIBLE);

-- ----------------------------------------------------------------------------
-- Table Comics.Series
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Comics`.`Series` (
  `SeriesID` INT NOT NULL,
  `SeriesName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`SeriesID`),
  UNIQUE INDEX `UQ_Series_SeriesName` (`SeriesName` ASC) VISIBLE);

-- ----------------------------------------------------------------------------
-- Table Comics.PageStoryArcs
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Comics`.`PageStoryArcs` (
  `PageStoryArcID` INT NOT NULL,
  `PageID` INT NOT NULL,
  `StoryArcID` INT NOT NULL,
  `CreationDate` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `ModificationDate` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`PageStoryArcID`),
  UNIQUE INDEX `UQ_PageStoryArcs_PageID_StoryArcID` (`PageID` ASC, `StoryArcID` ASC) VISIBLE,
  UNIQUE INDEX `UQ_PageStoryArcs_PageID` (`PageID` ASC) VISIBLE,
  CONSTRAINT `FK_PageStoryArcs_StoryArcs`
    FOREIGN KEY (`StoryArcID`)
    REFERENCES `Comics`.`StoryArcs` (`StoryArcID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_PageStoryArcs_Pages`
    FOREIGN KEY (`PageID`)
    REFERENCES `Comics`.`Pages` (`PageID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Comics.Pages
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Comics`.`Pages` (
  `PageID` INT NOT NULL,
  `IssueID` INT NOT NULL,
  `PageNumber` INT NOT NULL,
  `PageFileName` VARCHAR(255) NOT NULL,
  `PageType` TINYINT UNSIGNED NOT NULL,
  `CreationDate` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `ModificationDate` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `FileID` CHAR(10) CHARACTER SET 'utf8mb4' NULL,
  PRIMARY KEY (`PageID`),
  UNIQUE INDEX `UQ_Pages_IssueID_PageNumber` (`IssueID` ASC, `PageNumber` ASC) VISIBLE,
  CONSTRAINT `FK_Pages_Issues`
    FOREIGN KEY (`IssueID`)
    REFERENCES `Comics`.`Issues` (`IssueID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- View Comics.sp_upgraddiagrams
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
-- 	CREATE  OR REPLACE PROCEDURE dbo.sp_upgraddiagrams
-- 	AS
-- 	BEGIN
-- 		IF OBJECT_ID(N'dbo.sysdiagrams') IS NOT NULL
-- 			return 0;
-- 	
-- 		CREATE TABLE dbo.sysdiagrams
-- 		(
-- 			name sysname NOT NULL,
-- 			principal_id int NOT NULL,	-- we may change it to varbinary(85)
-- 			diagram_id int PRIMARY KEY IDENTITY,
-- 			version int,
-- 	
-- 			definition varbinary(max)
-- 			CONSTRAINT UK_principal_name UNIQUE
-- 			(
-- 				principal_id,
-- 				name
-- 			)
-- 		);
-- 
-- 
-- 		/* Add this if we need to have some form of extended properties for diagrams */
-- 		/*
-- 		IF OBJECT_ID(N'dbo.sysdiagram_properties') IS NULL
-- 		BEGIN
-- 			CREATE TABLE dbo.sysdiagram_properties
-- 			(
-- 				diagram_id int,
-- 				name sysname,
-- 				value varbinary(max) NOT NULL
-- 			)
-- 		END
-- 		*/
-- 
-- 		IF OBJECT_ID(N'dbo.dtproperties') IS NOT NULL
-- 		begin
-- 			insert into dbo.sysdiagrams
-- 			(
-- 				[name],
-- 				[principal_id],
-- 				[version],
-- 				[definition]
-- 			)
-- 			select	 
-- 				convert(sysname, dgnm.[uvalue]),
-- 				DATABASE_PRINCIPAL_ID(N'dbo'),			-- will change to the sid of sa
-- 				0,							-- zero for old format, dgdef.[version],
-- 				dgdef.[lvalue]
-- 			from dbo.[dtproperties] dgnm
-- 				inner join dbo.[dtproperties] dggd on dggd.[property] = 'DtgSchemaGUID' and dggd.[objectid] = dgnm.[objectid]	
-- 				inner join dbo.[dtproperties] dgdef on dgdef.[property] = 'DtgSchemaDATA' and dgdef.[objectid] = dgnm.[objectid]
-- 				
-- 			where dgnm.[property] = 'DtgSchemaNAME' and dggd.[uvalue] like N'_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
-- 			return 2;
-- 		end
-- 		return 1;
-- 	END
-- 	;

-- ----------------------------------------------------------------------------
-- View Comics.sp_helpdiagrams
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
-- 	CREATE  OR REPLACE PROCEDURE dbo.sp_helpdiagrams
-- 	(
-- 		@diagramname sysname = NULL,
-- 		@owner_id int = NULL
-- 	)
-- 	WITH EXECUTE AS N'dbo'
-- 	AS
-- 	BEGIN
-- 		DECLARE @user sysname
-- 		DECLARE @dboLogin bit
-- 		EXECUTE AS CALLER;
-- 			SET @user = USER_NAME();
-- 			SET @dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
-- 		REVERT;
-- 		SELECT
-- 			[Database] = DB_NAME(),
-- 			[Name] = name,
-- 			[ID] = diagram_id,
-- 			[Owner] = USER_NAME(principal_id),
-- 			[OwnerID] = principal_id
-- 		FROM
-- 			sysdiagrams
-- 		WHERE
-- 			(@dboLogin = 1 OR USER_NAME(principal_id) = @user) AND
-- 			(@diagramname IS NULL OR name = @diagramname) AND
-- 			(@owner_id IS NULL OR principal_id = @owner_id)
-- 		ORDER BY
-- 			4, 5, 1
-- 	END
-- 	;

-- ----------------------------------------------------------------------------
-- View Comics.sp_helpdiagramdefinition
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
-- 	CREATE  OR REPLACE PROCEDURE dbo.sp_helpdiagramdefinition
-- 	(
-- 		@diagramname 	sysname,
-- 		@owner_id	int	= null 		
-- 	)
-- 	WITH EXECUTE AS N'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 
-- 		declare @theId 		int
-- 		declare @IsDbo 		int
-- 		declare @DiagId		int
-- 		declare @UIDFound	int
-- 	
-- 		if(@diagramname is null)
-- 		begin
-- 			RAISERROR (N'E_INVALIDARG', 16, 1);
-- 			return -1
-- 		end
-- 	
-- 		execute as caller;
-- 		select @theId = DATABASE_PRINCIPAL_ID();
-- 		select @IsDbo = IS_MEMBER(N'db_owner');
-- 		if(@owner_id is null)
-- 			select @owner_id = @theId;
-- 		revert; 
-- 	
-- 		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname;
-- 		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId ))
-- 		begin
-- 			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
-- 			return -3
-- 		end
-- 
-- 		select version, definition FROM dbo.sysdiagrams where diagram_id = @DiagId ; 
-- 		return 0
-- 	END
-- 	;

-- ----------------------------------------------------------------------------
-- View Comics.sp_creatediagram
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
-- 	CREATE  OR REPLACE PROCEDURE dbo.sp_creatediagram
-- 	(
-- 		@diagramname 	sysname,
-- 		@owner_id		int	= null, 	
-- 		@version 		int,
-- 		@definition 	varbinary(max)
-- 	)
-- 	WITH EXECUTE AS 'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 	
-- 		declare @theId int
-- 		declare @retval int
-- 		declare @IsDbo	int
-- 		declare @userName sysname
-- 		if(@version is null or @diagramname is null)
-- 		begin
-- 			RAISERROR (N'E_INVALIDARG', 16, 1);
-- 			return -1
-- 		end
-- 	
-- 		execute as caller;
-- 		select @theId = DATABASE_PRINCIPAL_ID(); 
-- 		select @IsDbo = IS_MEMBER(N'db_owner');
-- 		revert; 
-- 		
-- 		if @owner_id is null
-- 		begin
-- 			select @owner_id = @theId;
-- 		end
-- 		else
-- 		begin
-- 			if @theId <> @owner_id
-- 			begin
-- 				if @IsDbo = 0
-- 				begin
-- 					RAISERROR (N'E_INVALIDARG', 16, 1);
-- 					return -1
-- 				end
-- 				select @theId = @owner_id
-- 			end
-- 		end
-- 		-- next 2 line only for test, will be removed after define name unique
-- 		if EXISTS(select diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @diagramname)
-- 		begin
-- 			RAISERROR ('The name is already used.', 16, 1);
-- 			return -2
-- 		end
-- 	
-- 		insert into dbo.sysdiagrams(name, principal_id , version, definition)
-- 				VALUES(@diagramname, @theId, @version, @definition) ;
-- 		
-- 		select @retval = @@IDENTITY 
-- 		return @retval
-- 	END
-- 	;

-- ----------------------------------------------------------------------------
-- View Comics.sp_renamediagram
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
-- 	CREATE  OR REPLACE PROCEDURE dbo.sp_renamediagram
-- 	(
-- 		@diagramname 		sysname,
-- 		@owner_id		int	= null,
-- 		@new_diagramname	sysname
-- 	
-- 	)
-- 	WITH EXECUTE AS 'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 		declare @theId 			int
-- 		declare @IsDbo 			int
-- 		
-- 		declare @UIDFound 		int
-- 		declare @DiagId			int
-- 		declare @DiagIdTarg		int
-- 		declare @u_name			sysname
-- 		if((@diagramname is null) or (@new_diagramname is null))
-- 		begin
-- 			RAISERROR ('Invalid value', 16, 1);
-- 			return -1
-- 		end
-- 	
-- 		EXECUTE AS CALLER;
-- 		select @theId = DATABASE_PRINCIPAL_ID();
-- 		select @IsDbo = IS_MEMBER(N'db_owner'); 
-- 		if(@owner_id is null)
-- 			select @owner_id = @theId;
-- 		REVERT;
-- 	
-- 		select @u_name = USER_NAME(@owner_id)
-- 	
-- 		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
-- 		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
-- 		begin
-- 			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
-- 			return -3
-- 		end
-- 	
-- 		-- if((@u_name is not null) and (@new_diagramname = @diagramname))	-- nothing will change
-- 		--	return 0;
-- 	
-- 		if(@u_name is null)
-- 			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @new_diagramname
-- 		else
-- 			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @owner_id and name = @new_diagramname
-- 	
-- 		if((@DiagIdTarg is not null) and  @DiagId <> @DiagIdTarg)
-- 		begin
-- 			RAISERROR ('The name is already used.', 16, 1);
-- 			return -2
-- 		end		
-- 	
-- 		if(@u_name is null)
-- 			update dbo.sysdiagrams set [name] = @new_diagramname, principal_id = @theId where diagram_id = @DiagId
-- 		else
-- 			update dbo.sysdiagrams set [name] = @new_diagramname where diagram_id = @DiagId
-- 		return 0
-- 	END
-- 	;

-- ----------------------------------------------------------------------------
-- View Comics.sp_alterdiagram
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
-- 	CREATE  OR REPLACE PROCEDURE dbo.sp_alterdiagram
-- 	(
-- 		@diagramname 	sysname,
-- 		@owner_id	int	= null,
-- 		@version 	int,
-- 		@definition 	varbinary(max)
-- 	)
-- 	WITH EXECUTE AS 'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 	
-- 		declare @theId 			int
-- 		declare @retval 		int
-- 		declare @IsDbo 			int
-- 		
-- 		declare @UIDFound 		int
-- 		declare @DiagId			int
-- 		declare @ShouldChangeUID	int
-- 	
-- 		if(@diagramname is null)
-- 		begin
-- 			RAISERROR ('Invalid ARG', 16, 1)
-- 			return -1
-- 		end
-- 	
-- 		execute as caller;
-- 		select @theId = DATABASE_PRINCIPAL_ID();	 
-- 		select @IsDbo = IS_MEMBER(N'db_owner'); 
-- 		if(@owner_id is null)
-- 			select @owner_id = @theId;
-- 		revert;
-- 	
-- 		select @ShouldChangeUID = 0
-- 		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
-- 		
-- 		if(@DiagId IS NULL or (@IsDbo = 0 and @theId <> @UIDFound))
-- 		begin
-- 			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
-- 			return -3
-- 		end
-- 	
-- 		if(@IsDbo <> 0)
-- 		begin
-- 			if(@UIDFound is null or USER_NAME(@UIDFound) is null) -- invalid principal_id
-- 			begin
-- 				select @ShouldChangeUID = 1 ;
-- 			end
-- 		end
-- 
-- 		-- update dds data			
-- 		update dbo.sysdiagrams set definition = @definition where diagram_id = @DiagId ;
-- 
-- 		-- change owner
-- 		if(@ShouldChangeUID = 1)
-- 			update dbo.sysdiagrams set principal_id = @theId where diagram_id = @DiagId ;
-- 
-- 		-- update dds version
-- 		if(@version is not null)
-- 			update dbo.sysdiagrams set version = @version where diagram_id = @DiagId ;
-- 
-- 		return 0
-- 	END
-- 	;

-- ----------------------------------------------------------------------------
-- View Comics.sp_dropdiagram
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
-- 	CREATE  OR REPLACE PROCEDURE dbo.sp_dropdiagram
-- 	(
-- 		@diagramname 	sysname,
-- 		@owner_id	int	= null
-- 	)
-- 	WITH EXECUTE AS 'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 		declare @theId 			int
-- 		declare @IsDbo 			int
-- 		
-- 		declare @UIDFound 		int
-- 		declare @DiagId			int
-- 	
-- 		if(@diagramname is null)
-- 		begin
-- 			RAISERROR ('Invalid value', 16, 1);
-- 			return -1
-- 		end
-- 	
-- 		EXECUTE AS CALLER;
-- 		select @theId = DATABASE_PRINCIPAL_ID();
-- 		select @IsDbo = IS_MEMBER(N'db_owner'); 
-- 		if(@owner_id is null)
-- 			select @owner_id = @theId;
-- 		REVERT; 
-- 		
-- 		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
-- 		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
-- 		begin
-- 			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
-- 			return -3
-- 		end
-- 	
-- 		delete from dbo.sysdiagrams where diagram_id = @DiagId;
-- 	
-- 		return 0;
-- 	END
-- 	;

-- ----------------------------------------------------------------------------
-- View Comics.fn_diagramobjects
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
-- 	CREATE  OR REPLACE FUNCTION dbo.fn_diagramobjects() 
-- 	RETURNS int
-- 	WITH EXECUTE AS N'dbo'
-- 	AS
-- 	BEGIN
-- 		declare @id_upgraddiagrams		int
-- 		declare @id_sysdiagrams			int
-- 		declare @id_helpdiagrams		int
-- 		declare @id_helpdiagramdefinition	int
-- 		declare @id_creatediagram	int
-- 		declare @id_renamediagram	int
-- 		declare @id_alterdiagram 	int 
-- 		declare @id_dropdiagram		int
-- 		declare @InstalledObjects	int
-- 
-- 		select @InstalledObjects = 0
-- 
-- 		select 	@id_upgraddiagrams = object_id(N'dbo.sp_upgraddiagrams'),
-- 			@id_sysdiagrams = object_id(N'dbo.sysdiagrams'),
-- 			@id_helpdiagrams = object_id(N'dbo.sp_helpdiagrams'),
-- 			@id_helpdiagramdefinition = object_id(N'dbo.sp_helpdiagramdefinition'),
-- 			@id_creatediagram = object_id(N'dbo.sp_creatediagram'),
-- 			@id_renamediagram = object_id(N'dbo.sp_renamediagram'),
-- 			@id_alterdiagram = object_id(N'dbo.sp_alterdiagram'), 
-- 			@id_dropdiagram = object_id(N'dbo.sp_dropdiagram')
-- 
-- 		if @id_upgraddiagrams is not null
-- 			select @InstalledObjects = @InstalledObjects + 1
-- 		if @id_sysdiagrams is not null
-- 			select @InstalledObjects = @InstalledObjects + 2
-- 		if @id_helpdiagrams is not null
-- 			select @InstalledObjects = @InstalledObjects + 4
-- 		if @id_helpdiagramdefinition is not null
-- 			select @InstalledObjects = @InstalledObjects + 8
-- 		if @id_creatediagram is not null
-- 			select @InstalledObjects = @InstalledObjects + 16
-- 		if @id_renamediagram is not null
-- 			select @InstalledObjects = @InstalledObjects + 32
-- 		if @id_alterdiagram  is not null
-- 			select @InstalledObjects = @InstalledObjects + 64
-- 		if @id_dropdiagram is not null
-- 			select @InstalledObjects = @InstalledObjects + 128
-- 		
-- 		return @InstalledObjects 
-- 	END
-- 	;

-- ----------------------------------------------------------------------------
-- View Comics.usp_StoryArcs_GetByStoryLine
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
-- CREATE     OR REPLACE PROCEDURE [dbo].[usp_StoryArcs_GetByStoryLine]
-- 	@parmStoryLineName		VARCHAR(255),
-- 	@parmStoryArcName		VARCHAR(255)
-- AS
-- BEGIN
-- 	SELECT
-- 		StoryArcs.StoryArcID,
-- 		StoryArcs.StoryArcName,
-- 		StoryArcs.IsUnnamed,
-- 		StoryLines.StoryLineID,
-- 		StoryLines.StoryLineName
-- 	FROM StoryArcs
-- 		INNER JOIN StoryLines ON
-- 			StoryArcs.StoryLineID = StoryLines.StoryLineID
-- 	WHERE
-- 		StoryLines.StoryLineName = @parmStoryLineName
-- 		AND StoryArcs.StoryArcName = @parmStoryArcName
-- 	ORDER BY 
-- 		StoryLines.StoryLineName,
-- 		StoryArcs.StoryArcName
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_StoryArc_Get
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
-- CREATE     OR REPLACE PROCEDURE [dbo].[usp_StoryArc_Get] 
-- 	@parmSeriesName		VARCHAR(255),
-- 	@parmIssueNumber	DECIMAL,
-- 	@parmPageNumber		INT
-- AS
-- BEGIN
-- 
-- 	SELECT 
-- 		StoryArcs.StoryArcID,
-- 		StoryArcs.StoryArcName,
-- 		StoryArcs.StoryLineID,
-- 		StoryArcs.LastQuickPickDate,
-- 		StoryArcs.CreationDate,
-- 		StoryArcs.ModificationDate,
-- 		StoryArcs.IsUnnamed,
-- 		StoryLines.StoryLineID,
-- 		StoryLines.StoryLineName
-- 	FROM Series
-- 		INNER JOIN Issues 
-- 			INNER JOIN Pages
-- 				INNER JOIN PageStoryArcs
-- 					INNER JOIN StoryArcs
-- 						INNER JOIN StoryLines
-- 						ON StoryArcs.StoryLineID = StoryLines.StoryLineID
-- 					ON PageStoryArcs.StoryArcID = StoryArcs.StoryArcID
-- 				ON Pages.PageID = PageStoryArcs.PageID
-- 			ON Issues.IssueID = Pages.IssueID
-- 		ON Series.SeriesID = Issues.SeriesID
-- 	WHERE
-- 		Series.SeriesName = @parmSeriesName
-- 		AND Issues.IssueNumber = @parmIssueNumber
-- 		AND Pages.PageNumber = @parmPageNumber
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_Series_GetAll
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- CREATE  OR REPLACE PROCEDURE usp_Series_GetAll
-- AS
-- BEGIN
-- 	SELECT 
-- 		Series.SeriesID,
-- 		Series.SeriesName
-- 	FROM Series
-- 	ORDER BY Series.SeriesName
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_SeriesIssues_Get
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- CREATE  OR REPLACE PROCEDURE [dbo].[usp_SeriesIssues_Get]
--     @parmSeriesName		VARCHAR(255),
--     @parmIssueFrom		DECIMAL,
--     @parmIssueTo		DECIMAL
--     --out SortedSet<cIssue> issueList) {
-- AS
-- BEGIN
-- 	SELECT 
-- 		Series.SeriesID,
-- 		Series.SeriesName,
-- 		Issues.IssueID,
-- 		Issues.IssueNumber,
-- 		Issues.FilePath
-- 	FROM Issues
-- 		INNER JOIN Series ON Issues.SeriesID = Issues.SeriesID
-- 	WHERE 
-- 		Series.SeriesName = @parmSeriesName
-- 		AND Issues.IssueNumber >= @parmIssueFrom
-- 		AND Issues.IssueNumber <= @parmIssueTo
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_SystemSettings_Get
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- -- =============================================
-- -- Author:		<Author,,Name>
-- -- Create date: <Create Date,,>
-- -- Description:	<Description,,>
-- -- =============================================
-- CREATE  OR REPLACE PROCEDURE usp_SystemSettings_Get 
-- AS
-- BEGIN
-- 	-- SET NOCOUNT ON added to prevent extra result sets from
-- 	-- interfering with SELECT statements.
-- 	SET NOCOUNT ON;
-- 
--     -- Insert statements for procedure here
-- 	SELECT * FROM SystemSettings
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_StoryLineStoryArcs_Get
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
-- CREATE     OR REPLACE PROCEDURE [dbo].[usp_StoryLineStoryArcs_Get] 
--     @parmSeriesName		VARCHAR(255),
-- 	@parmIssueFrom		DECIMAL,
--     @parmIssueTo		DECIMAL,
--     @parmStoryLineName	VARCHAR(255)
--     --out cStoryArc[] storyArcs) {
-- AS
-- BEGIN
-- 	SELECT 
-- 		StoryArcs.StoryArcID,
-- 		StoryArcs.StoryArcName,
-- 		StoryArcs.IsUnnamed,
-- 		StoryArcs.StoryLineID,
-- 		StoryLines.StoryLineName
-- 	FROM
-- 		StoryLines 
-- 			INNER JOIN StoryArcs 
-- 				INNER JOIN PageStoryArcs 
-- 					INNER JOIN Pages 
-- 						INNER JOIN Issues 
-- 							INNER JOIN Series ON
-- 								Issues.SeriesID = Series.SeriesID ON
-- 							Pages.IssueID = Issues.IssueID ON
-- 						PageStoryArcs.PageID = Pages.PageID ON
-- 					StoryArcs.StoryArcID = PageStoryArcs.StoryArcID ON
-- 				StoryLines.StoryLineID = StoryArcs.StoryLineID
-- 	WHERE
-- 		Series.SeriesName = @parmSeriesName
-- 		AND Issues.IssueNumber >= @parmIssueFrom
-- 		AND Issues.IssueNumber <= @parmIssueTo
-- 		AND StoryLines.StoryLineName = @parmStoryLineName
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_Pages_Get
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
--  CREATE    OR REPLACE PROCEDURE [dbo].[usp_Pages_Get]
--     @parmSeriesID		int,
--     @parmStoryLineID	int,
--     @parmIssueFrom		DECIMAL,
--     @parmIssueTo		DECIMAL
-- AS
-- BEGIN
-- 	SELECT 
-- 		PagesView.StoryLineID,
-- 		PagesView.StoryLineName,
-- 		PagesView.StoryArcName,
-- 		PagesView.StoryArcID,
-- 		PagesView.LastQuickPickDate,
-- 		PagesView.PageID,
-- 		PagesView.PageNumber,
-- 		PagesView.PageFileName,
-- 		PagesView.PageType,
-- 		PagesView.IssueID,
-- 		PagesView.IssueNumber,
-- 		PagesView.FilePath,
-- 		PagesView.SeriesID,
-- 		PagesView.SeriesName
-- 	FROM PagesView
-- 	WHERE
-- 		PagesView.SeriesID = @parmSeriesID
-- 		AND PagesView.StoryLineID = COALESCE(@parmStoryLineID, PagesView.StoryLineID)
-- 		AND PagesView.IssueNumber >= COALESCE(@parmIssueFrom, PagesView.IssueNumber)
-- 		AND PagesView.IssueNumber <= COALESCE(@parmIssueTo, PagesView.IssueNumber)
-- 	ORDER BY 
-- 		PagesView.SeriesName,
-- 		PagesView.StoryLineName,
-- 		PagesView.StoryArcName,
-- 		PagesView.IssueNumber,
-- 		PagesView.PageNumber
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_StoryArc_UpdateLastQuickPickDate
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- CREATE  OR REPLACE PROCEDURE usp_StoryArc_UpdateLastQuickPickDate
-- --    @parmSeriesName			VARCHAR(255),
-- 	@parmStoryLineName		VARCHAR(255),
-- 	@parmStoryArcName		VARCHAR(255),
--     @parmLastQuickPickDate	DATETIME
-- AS
-- BEGIN
-- 
-- 	DECLARE @StoryArcID INT
-- 
-- 	IF EXISTS(
-- 		SELECT 1
-- 		FROM StoryLines
-- 			INNER JOIN StoryArcs ON StoryLines.StoryLineID = StoryArcs.StoryLineID
-- 		WHERE
-- 			StoryLines.StoryLineName = @parmStoryLineName
-- 			AND StoryArcs.StoryArcName = @parmStoryArcName)
-- 	
-- 	BEGIN
-- 		UPDATE StoryArcs
-- 		SET StoryArcs.LastQuickPickDate = @parmLastQuickPickDate
-- 		WHERE StoryArcID IN (
-- 			SELECT StoryArcID
-- 			FROM StoryLines
-- 				INNER JOIN StoryArcs ON StoryLines.StoryLineID = StoryArcs.StoryLineID
-- 			WHERE
-- 				StoryLines.StoryLineName = @parmStoryLineName
-- 				AND StoryArcs.StoryArcName = @parmStoryArcName
-- 		)
-- 	END
-- 
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_Issue_UpdateFileName
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- CREATE  OR REPLACE PROCEDURE usp_Issue_UpdateFileName
-- 	@parmOriginalFilePath	VARCHAR(255),
-- 	@parmNewFilePath		VARCHAR(255)
-- AS
-- 
-- BEGIN
-- 
-- 	UPDATE Issues
-- 	SET Issues.FilePath = @parmNewFilePath
-- 	WHERE Issues.FilePath = @parmOriginalFilePath;
-- 
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_Issues_Get
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
--  CREATE    OR REPLACE PROCEDURE [dbo].[usp_Issues_Get]
--     @parmSeriesID		INT=NULL,
--     @parmStoryLineID	INT=NULL,
--     @parmIssueFrom		DECIMAL=NULL,
--     @parmIssueTo		DECIMAL=NULL
-- AS
-- BEGIN
-- 
-- 	SELECT 
-- 		Issues.IssueID,
-- 		Issues.IssueNumber,
-- 		Issues.FilePath,
-- 		Series.SeriesID,
-- 		Series.SeriesName
-- 	FROM Series INNER JOIN 
-- 		Issues INNER JOIN Pages 
-- 			INNER JOIN PageStoryArcs 
-- 				INNER JOIN StoryArcs 
-- 					INNER JOIN StoryLines ON 
-- 						StoryArcs.StoryLineID = StoryLines.StoryLineID ON
-- 					PageStoryArcs.StoryArcID = StoryArcs.StoryArcID ON
-- 				Pages.PageID = PageStoryArcs.PageID ON
-- 			Issues.IssueID = Pages.IssueID ON
-- 		Series.SeriesID = Issues.SeriesID
-- 	WHERE 
-- 		Series.SeriesID = COALESCE(@parmSeriesID, Series.SeriesID)
-- 		AND StoryLines.StoryLineID = COALESCE(CASE WHEN @parmStoryLineID <= 0 THEN StoryLines.StoryLineID ELSE @parmStoryLineID END, StoryLines.StoryLineID)
-- 		AND Issues.IssueNumber >= COALESCE(@parmIssueFrom, Issues.IssueNumber)
-- 		AND Issues.IssueNumber <= COALESCE(@parmIssueTo, Issues.IssueNumber)
-- 	GROUP BY
-- 		Series.SeriesID,
-- 		Series.SeriesName,
-- 		Issues.IssueID,
-- 		Issues.IssueNumber,
-- 		Issues.FilePath
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_PageImage_GetByIssue
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- CREATE  OR REPLACE PROCEDURE usp_PageImage_GetByIssue
--     @parmPageIndex		INT
--     --out cIssue issue) {
-- AS
-- BEGIN
-- 
-- --print '@parmIssueNumber = ' + CAST(@parmIssueNumber AS VARCHAR(20))
-- 
-- 	SELECT 
-- 		PageImages.PageImageID,
-- 		Images.ImageID,
-- 		Images.ImageData
-- 	FROM PageImages 
-- 	INNER JOIN Images ON 
-- 	PageImages.imageid = Images.ImageID
-- 	WHERE 
-- 		pageimages.PageID = @parmPageIndex
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_LibraryFolders_Get
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
-- CREATE  OR REPLACE PROCEDURE usp_LibraryFolders_Get 
-- AS
-- BEGIN
-- 	SELECT * FROM LibraryFolders
-- 	ORDER BY LibraryFolders.LibraryFolderPath
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_LibraryFolders_Create
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
-- CREATE  OR REPLACE PROCEDURE usp_LibraryFolders_Create
-- 	@parmLibraryFolderPath			VARCHAR(255),
-- 	@parmLibraryFolderDescription	VARCHAR(255)
-- AS
-- BEGIN
-- 	INSERT INTO LibraryFolders (
-- 		LibraryFolderPath,
-- 		LibraryFolderDescription
-- 	)
-- 	VALUES (
-- 		@parmLibraryFolderPath,
-- 		@parmLibraryFolderDescription
-- 	)
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_LibraryFolders_Update
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
-- CREATE  OR REPLACE PROCEDURE usp_LibraryFolders_Update
-- 	@parmLibraryFolderID			INT,
-- 	@parmLibraryFolderDescription	VARCHAR(255)
-- AS
-- BEGIN
-- 	UPDATE LibraryFolders
-- 	SET LibraryFolders.LibraryFolderDescription = @parmLibraryFolderDescription
-- 	WHERE LibraryFolders.LibraryFolderID = @parmLibraryFolderID
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_PageImage_Create
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- CREATE  OR REPLACE PROCEDURE usp_PageImage_Create
--     @parmPageIndex		INT,
-- 	@parmPageBytes		VARBINARY(MAX)
-- AS
-- BEGIN
-- 
-- INSERT INTO Images (imageData)
-- VALUES(@parmPageBytes)
-- 
-- INSERT INTO PageImages (PageID, ImageID, ImageBytes)
-- VALUES(@parmPageIndex, @@IDENTITY, @parmPageBytes)
-- 
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_PageInfo_GetById
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- CREATE  OR REPLACE PROCEDURE [dbo].[usp_PageInfo_GetById]
--     @parmPageId		INT
-- AS
-- BEGIN
-- 
-- 	SELECT
-- 		PagesView.SeriesID,
-- 		PagesView.SeriesName,
-- 		PagesView.StoryLineID,
-- 		PagesView.StoryLineName,
-- 		PagesView.PageStoryArcID,
-- 		PagesView.StoryArcID,
-- 		PagesView.StoryArcName,
-- 		PagesView.LastQuickPickDate,
-- 		PagesView.IssueID,
-- 		PagesView.IssueNumber,
-- 		PagesView.FilePath,
-- 		PagesView.PageID,
-- 		PagesView.PageNumber,
-- 		PagesView.PageFileName,
-- 		PagesView.PageType,
-- --		Pages.StoryArcID,
-- --		Pages.PageType,
-- 		PagesView.PagesModificationDate
-- 	FROM PagesView
-- 	WHERE
-- 		PagesView.PageID = @parmPageId
-- 	ORDER BY
-- 		PagesView.StoryArcsModificationDate DESC,
-- 		PagesView.SeriesName,
-- 		PagesView.IssueNumber,
-- 		PagesView.PageNumber
-- 
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_Issues_Upsert
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
--  CREATE    OR REPLACE PROCEDURE [dbo].[usp_Issues_Upsert] 
-- 	@parmSeriesName		varchar(255),
-- 	@parmIssueNumber	decimal(8, 4),
-- 	@parmFilePath		varchar(255),
-- 	@parmIssueID		int OUTPUT
-- AS
-- 
-- BEGIN
-- 
-- 	DECLARE @SeriesID int = -1
-- 
-- 	PRINT ' '
-- 	PRINT 'START usp_Issues_Upsert ''' + 
-- 		@parmSeriesName + ''', ' + 
-- 		CAST(@parmIssueNumber AS VARCHAR(MAX)) + ', ''' + 
-- 		@parmFilePath + ''''
-- 
-- 	SELECT @parmIssueID = IssueID
-- 	FROM Issues 
-- 		INNER JOIN Series ON Issues.SeriesID = Series.SeriesID
-- 	WHERE Series.SeriesName = @parmSeriesName
-- 		AND Issues.IssueNumber = @parmIssueNumber
-- 
-- 	IF @parmIssueID IS NULL OR @parmIssueID < 0
-- 	BEGIN
-- 
-- 	PRINT 'Issue was not found.  Calling usp_Series_Upsert ''' + @parmSeriesName + '''' 
-- 	EXEC usp_Series_Upsert
-- 		@parmSeriesName	= @parmSeriesName,
-- 		@parmSeriesID = @SeriesID OUTPUT
-- 
-- 	PRINT 'INSERTING Into Issues' 
-- 		INSERT INTO Issues(SeriesID, IssueNumber, FilePath)
-- 		SELECT @SeriesID, @parmIssueNumber, @parmFilePath
-- 
-- 	PRINT 'Retrieving IssueID' 
-- 		SELECT @parmIssueID = IssueID
-- 		FROM Issues
-- 		WHERE 
-- 			Issues.SeriesID = @SeriesID
-- 			AND Issues.IssueNumber = @parmIssueNumber
-- 	PRINT 'Found IssueID ' + CAST(@parmIssueID AS VARCHAR(MAX)) 
-- 
-- 	END
-- 	ELSE
-- 	BEGIN
-- 
-- 		PRINT 'Issue was found.  UPDATING Issue (FilePath = ''' + @parmFilePath + ''') WHERE IssueID = ' + CAST(@parmIssueID AS VARCHAR(MAX))
-- 
-- 		UPDATE Issues
-- 		SET FilePath = @parmFilePath
-- 		WHERE IssueID = @parmIssueID
-- 
-- 	END
-- 
-- 	PRINT 'END usp_Issues_Upsert'
-- 	PRINT ' '
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_PageInfo_GetByIssue
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- CREATE  OR REPLACE PROCEDURE [dbo].[usp_PageInfo_GetByIssue]
--     @parmIssueId		INT
-- AS
-- BEGIN
-- 
-- 	SELECT
-- 		PagesView.SeriesID,
-- 		PagesView.SeriesName,
-- 		PagesView.StoryLineID,
-- 		PagesView.StoryLineName,
-- 		PagesView.PageStoryArcID,
-- 		PagesView.StoryArcID,
-- 		PagesView.StoryArcName,
-- 		PagesView.LastQuickPickDate,
-- 		PagesView.IssueID,
-- 		PagesView.IssueNumber,
-- 		PagesView.FilePath,
-- 		PagesView.PageID,
-- 		PagesView.PageNumber,
-- 		PagesView.PageFileName,
-- 		PagesView.PageType,
-- --		Pages.StoryArcID,
-- --		Pages.PageType,
-- 		PagesView.PagesModificationDate
-- 	FROM PagesView
-- 	WHERE
-- 		PagesView.IssueID = @parmIssueId
-- 	ORDER BY
-- 		PagesView.StoryArcsModificationDate DESC,
-- 		PagesView.SeriesName,
-- 		PagesView.IssueNumber,
-- 		PagesView.PageNumber
-- 
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_Pages_GetByIssue
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- CREATE  OR REPLACE PROCEDURE [dbo].[usp_Pages_GetByIssue]
-- 	@parmSeriesID		INT,
-- 	@parmIssueNumber	DECIMAL(8, 4)
-- AS
-- BEGIN
-- 
-- 	SELECT
-- 		PagesView.StoryLineID,
-- 		PagesView.StoryLineName,
-- 		PagesView.StoryArcID,
-- 		PagesView.StoryArcName,
-- 		PagesView.LastQuickPickDate,
-- 		PagesView.PageID,
-- 		PagesView.PageNumber,
-- 		PagesView.PageFileName,
-- 		PagesView.PageType,
-- 		PagesView.IssueID,
-- 		PagesView.IssueNumber,
-- 		PagesView.FilePath,
-- 		PagesView.SeriesID,
-- 		PagesView.SeriesName
-- 	FROM PagesView
-- 	WHERE
-- 		PagesView.SeriesID = @parmSeriesID
-- 		AND PagesView.IssueNumber = @parmIssueNumber
-- 	ORDER BY
-- 		PagesView.SeriesName,
-- 		PagesView.IssueNumber,
-- 		PagesView.PageNumber
-- 
-- 
-- 	/*SELECT
-- 		StoryLines.StoryLineName,
-- 		StoryArcs.StoryArcName,
-- 		Pages.PageID,
-- 		Pages.PageNumber,
-- 		Pages.PageFileName,
-- 		Pages.PageType,
-- 		Issues.IssueNumber,
-- 		Issues.FilePath,
-- 		Series.SeriesName
-- 	FROM
-- 		StoryLines 
-- 			INNER JOIN StoryArcs 
-- 				INNER JOIN PageStoryArcs 
-- 					INNER JOIN Pages 
-- 						INNER JOIN Issues 
-- 							INNER JOIN Series ON
-- 								Issues.SeriesID = Series.SeriesID ON
-- 							Pages.IssueID = Issues.IssueID ON
-- 						PageStoryArcs.PageID = Pages.PageID ON
-- 					StoryArcs.StoryArcID = PageStoryArcs.StoryArcID ON
-- 				StoryLines.StoryLineID = StoryArcs.StoryLineID
-- 	WHERE
-- 		Series.SeriesName = @parmSeriesName
-- 		AND Issues.IssueNumber = @parmIssueNumber
-- 	ORDER BY
-- 		Series.SeriesName,
-- 		Issues.IssueNumber,
-- 		Pages.PageNumber*/
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_Pages_GetByIssueId
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- CREATE  OR REPLACE PROCEDURE [dbo].[usp_Pages_GetByIssueId]
-- 	@parmIssueId		INT
-- AS
-- BEGIN
-- 
-- 	SELECT
-- 		PagesView.StoryLineID,
-- 		PagesView.StoryLineName,
-- 		PagesView.StoryArcID,
-- 		PagesView.StoryArcName,
-- 		PagesView.LastQuickPickDate,
-- 		PagesView.PageID,
-- 		PagesView.PageNumber,
-- 		PagesView.PageFileName,
-- 		PagesView.PageType,
-- 		PagesView.IssueID,
-- 		PagesView.IssueNumber,
-- 		PagesView.FilePath,
-- 		PagesView.SeriesID,
-- 		PagesView.SeriesName
-- 	FROM PagesView
-- 	WHERE
-- 		PagesView.IssueID = @parmIssueId
-- 	ORDER BY
-- 		PagesView.SeriesName,
-- 		PagesView.IssueNumber,
-- 		PagesView.PageNumber
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_PageInfo_Get
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- CREATE  OR REPLACE PROCEDURE [dbo].[usp_PageInfo_Get]
--     @parmSeriesName		VARCHAR(255),
--     @parmIssueNumber	DECIMAL(8, 4),
--     @parmPageNumber		INT
--     --out cPageInfo pageInfo) {
-- AS
-- BEGIN
-- 
-- 	SELECT
-- 		PagesView.SeriesID,
-- 		PagesView.SeriesName,
-- 		PagesView.StoryLineID,
-- 		PagesView.StoryLineName,
-- 		PagesView.PageStoryArcID,
-- 		PagesView.StoryArcID,
-- 		PagesView.StoryArcName,
-- 		PagesView.LastQuickPickDate,
-- 		PagesView.IssueID,
-- 		PagesView.IssueNumber,
-- 		PagesView.FilePath,
-- 		PagesView.PageID,
-- 		PagesView.PageNumber,
-- 		PagesView.PageFileName,
-- 		PagesView.PageType,
-- --		Pages.StoryArcID,
-- --		Pages.PageType,
-- 		PagesView.PagesModificationDate
-- 	FROM PagesView
-- 	WHERE
-- 		PagesView.SeriesName = @parmSeriesName
-- 		AND PagesView.IssueNumber = @parmIssueNumber
-- 		AND PagesView.PageNumber = @parmPageNumber
-- 	ORDER BY
-- 		PagesView.StoryArcsModificationDate DESC,
-- 		PagesView.SeriesName,
-- 		PagesView.IssueNumber,
-- 		PagesView.PageNumber
-- 
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_Issue_GetByPage
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- CREATE  OR REPLACE PROCEDURE [dbo].[usp_Issue_GetByPage]
--     @parmSeriesName		VARCHAR(255),
--     @parmIssueNumber	DECIMAL(8, 4)
--     --out cIssue issue) {
-- AS
-- BEGIN
-- 
-- --print '@parmIssueNumber = ' + CAST(@parmIssueNumber AS VARCHAR(20))
-- 
-- 	SELECT 
-- 		Issues.IssueID,
-- 		Issues.IssueNumber,
-- 		Issues.FilePath,
-- 		Issues.SeriesID,
-- 		Series.SeriesName
-- 	FROM Issues
-- 		INNER JOIN Series ON Issues.SeriesID = Series.SeriesID
-- 	WHERE 
-- 		Series.SeriesName = @parmSeriesName
-- 		AND Issues.IssueNumber = @parmIssueNumber
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_Issue_GetByFilePath
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- CREATE  OR REPLACE PROCEDURE usp_Issue_GetByFilePath
--     @parmFilePath	VARCHAR(255)
-- AS
-- BEGIN
-- 
-- 	SELECT 
-- 		Issues.IssueID,
-- 		Issues.IssueNumber,
-- 		Issues.FilePath,
-- 		Issues.SeriesID,
-- 		Series.SeriesName
-- 	FROM Issues
-- 		INNER JOIN Series ON Issues.SeriesID = Issues.SeriesID
-- 	WHERE 
-- 		Issues.FilePath = @parmFilePath
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_StoryArcs_Get
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
-- CREATE    OR REPLACE PROCEDURE [dbo].[usp_StoryArcs_Get]
-- AS
-- BEGIN
-- 	SELECT TOP 20
-- 		StoryArcs.StoryArcID,
-- 		StoryArcs.StoryArcName,
-- 		StoryArcs.IsUnnamed,
-- 		StoryArcs.LastQuickPickDate,
-- 		StoryLines.StoryLineID,
-- 		StoryLines.StoryLineName
-- 	FROM StoryLines 
-- 		INNER JOIN StoryArcs
-- --			INNER JOIN PageStoryArcs 
-- 				--INNER JOIN Pages 
-- 				--	INNER JOIN Issues 
-- 				--		INNER JOIN Series ON Issues.SeriesID = Series.SeriesID ON 
-- 				--		Pages.IssueID = Pages.IssueID ON 
-- 				--	PageStoryArcs.PageID = Pages.PageID 
-- --				ON 
-- --				StoryArcs.StoryArcID = PageStoryArcs.StoryArcID 
-- ON
-- 			StoryLines.StoryLineID = StoryArcs.StoryLineID
-- 	WHERE (StoryLines.StoryLineName IS NOT NULL AND LEN(RTRIM(StoryLines.StoryLineName)) > 0) 
-- 		   OR 
-- 		  (StoryArcs.StoryArcName IS NOT NULL AND LEN(RTRIM(StoryArcs.StoryArcName)) > 0)
-- 	ORDER BY 
-- 		StoryArcs.LastQuickPickDate DESC,
-- 		StoryLines.StoryLineName,
-- 		StoryArcs.StoryArcName
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_StoryArcs_Upsert
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
-- CREATE     OR REPLACE PROCEDURE [dbo].[usp_StoryArcs_Upsert] 
-- 	@parmStoryLineName	varchar(255),
-- 	@parmStoryArcName	varchar(255),
-- 	@parmStoryArcID		int OUTPUT
-- AS
-- 
-- BEGIN
-- 
-- 	PRINT ' '
-- 	PRINT 'START usp_StoryArcs_Upsert ''' + 
-- 		COALESCE(@parmStoryLineName, 'NULL') + ''', ''' + 
-- 		COALESCE(@parmStoryArcName, 'NULL') + ''''
-- 
-- 	DECLARE @StoryLineID int
-- 
-- 	SELECT @parmStoryArcID = StoryArcID
-- 	FROM StoryArcs
-- 		INNER JOIN StoryLines ON StoryArcs.StoryLineID = StoryLines.StoryLineID
-- 	WHERE StoryLines.StoryLineName = @parmStoryLineName
-- 		AND StoryArcs.StoryArcName = @parmStoryArcName
-- 
-- 
-- 	IF @parmStoryArcID IS NULL
-- 	BEGIN
-- 	PRINT 'Calling usp_Storylines_Upsert'
-- 
-- 	EXEC usp_Storylines_Upsert
-- 		@parmStoryLineName	= @parmStoryLineName,
-- 		@parmStoryLineID = @StoryLineID OUTPUT
-- 
-- 	IF @StoryLineID IS NULL
-- 	BEGIN
-- 		PRINT 'END usp_StoryArcs_Upsert; Exiting after Storyline Upsert returned NULL StoryLineID' 
-- 		PRINT ' '
-- 
-- 		RETURN;
-- 	END
-- 
-- 	PRINT 'INSERTING Into StoryArcs'
-- 		INSERT INTO StoryArcs(StoryLineID, StoryArcName, IsUnnamed, LastQuickPickDate, CreationDate, ModificationDate)
-- 		SELECT @StoryLineID, COALESCE(@parmStoryArcName,''), CASE WHEN @parmStoryArcName IS NULL THEN 1 WHEN LEN(@parmStoryArcName) = 0 THEN 1 ELSE 0 END, GETDATE(), GetDAte(), GetDAte()
-- 
-- 	PRINT 'Looking up StoryArcID'
-- 		SELECT @parmStoryArcID = StoryArcID
-- 		FROM StoryArcs
-- 		WHERE 
-- 			StoryArcs.StoryLineID = @StoryLineID
-- 			AND StoryArcs.StoryArcName = COALESCE(@parmStoryArcName,'')
-- 	END
-- 	ELSE
-- 	BEGIN
-- 
-- 		PRINT 'FOUND StoryArcID: ' + CAST(@parmStoryArcID AS VARCHAR(MAX))
-- 
-- 		PRINT 'UPDATING StoryArc'
-- 
-- 		UPDATE StoryArcs SET LastQuickPickDate = GetDate(), ModificationDate = GetDate()
-- 		FROM StoryArcs
-- 			INNER JOIN StoryLines ON StoryArcs.StoryLineID = StoryLines.StoryLineID
-- 		WHERE StoryLines.StoryLineName = @parmStoryLineName
-- 			AND StoryArcs.StoryArcName = COALESCE(@parmStoryArcName,'')
-- 
-- 	END
-- 
-- 	PRINT 'END usp_StoryArcs_Upsert' 
-- 	PRINT ' '
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_Series_Upsert
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
-- CREATE     OR REPLACE PROCEDURE [dbo].[usp_Series_Upsert]
-- 	@parmSeriesName	varchar(255),
-- 	@parmSeriesID	int OUTPUT
-- AS
-- BEGIN
-- 
-- 	PRINT ' '
-- 	PRINT 'START usp_Series_Upsert ''' + 
-- 		@parmSeriesName + ''', ' + 
-- 		CAST(@parmSeriesID AS VARCHAR(MAX)) 
-- 
-- 	PRINT 'LOOKING UP SeriesID'
-- 	SELECT @parmSeriesID = SeriesID
-- 	FROM Series
-- 	WHERE Series.SeriesName = @parmSeriesName
-- 
-- 	IF @@ROWCOUNT = 0
-- 	BEGIN
-- 
-- 		PRINT 'Did not find Series.  INSERTING'
-- 
-- 		INSERT INTO Series (SeriesName)
-- 		SELECT @parmSeriesName
-- 
-- 		PRINT 'Looking Up Series'
-- 		SELECT @parmSeriesID = SeriesID
-- 		FROM Series
-- 		WHERE Series.SeriesName = @parmSeriesName
-- 	END
-- 
-- 	PRINT 'END usp_Series_Upsert'
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.PagesView
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- CREATE  OR REPLACE VIEW [dbo].[PagesView]
-- AS
-- SELECT        dbo.Series.SeriesID, dbo.Series.SeriesName, dbo.Issues.IssueID, dbo.Issues.IssueNumber, dbo.Issues.FilePath, dbo.Pages.PageID, 
--                          dbo.Pages.PageNumber, dbo.Pages.PageFileName, dbo.Pages.PageType, dbo.PageStoryArcs.PageStoryArcID, dbo.StoryArcs.StoryArcID, 
--                          dbo.StoryArcs.StoryArcName, dbo.StoryArcs.IsUnnamed, dbo.StoryLines.StoryLineID, dbo.StoryLines.StoryLineName, dbo.StoryArcs.LastQuickPickDate, dbo.Pages.ModificationDate AS PagesModificationDate, StoryArcs.ModificationDate AS StoryArcsModificationDate
-- FROM            dbo.Issues RIGHT OUTER JOIN
--                          dbo.Pages ON dbo.Issues.IssueID = dbo.Pages.IssueID LEFT OUTER JOIN
--                          dbo.PageStoryArcs ON dbo.Pages.PageID = dbo.PageStoryArcs.PageID LEFT OUTER JOIN
--                          dbo.Series ON dbo.Issues.SeriesID = dbo.Series.SeriesID LEFT OUTER JOIN
--                          dbo.StoryArcs ON dbo.PageStoryArcs.StoryArcID = dbo.StoryArcs.StoryArcID LEFT OUTER JOIN
--                          dbo.StoryLines ON dbo.StoryArcs.StoryLineID = dbo.StoryLines.StoryLineID
-- 
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_Storylines_Upsert
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
-- CREATE     OR REPLACE PROCEDURE [dbo].[usp_Storylines_Upsert]
-- 	@parmStoryLineName	varchar(255),
-- 	@parmStoryLineID	int OUTPUT
-- AS
-- BEGIN
-- 	PRINT ' '
-- 	PRINT 'START usp_Storylines_Upsert ''' + 
-- 		COALESCE(@parmStoryLineName, 'NULL') + ''''
-- 
-- 	if @parmStoryLineName IS NULL
-- 	BEGIN
-- 		PRINT 'END usp_Storylines_Upsert; Not inserting NULL StoryLine' 
-- 		PRINT ' ' 
-- 
-- 		RETURN;
-- 	END
-- 
-- 	SELECT @parmStoryLineID = StoryLineID
-- 	FROM StoryLines
-- 	WHERE StoryLines.StoryLineName = @parmStoryLineName
-- 
-- 	IF @@ROWCOUNT = 0
-- 	BEGIN
-- 		INSERT INTO StoryLines (StoryLineName)
-- 		SELECT @parmStoryLineName
-- 
-- 		SELECT @parmStoryLineID = StoryLineID
-- 		FROM StoryLines
-- 		WHERE StoryLines.StoryLineName = @parmStoryLineName
-- 	END
-- 
-- 	PRINT 'END usp_Storylines_Upsert' 
-- 	PRINT ' ' 
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_Pages_Upsert
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
--  CREATE    OR REPLACE PROCEDURE [dbo].[usp_Pages_Upsert]
-- 	@parmSeriesName		VARCHAR(255),
-- 	@parmIssueNumber	DECIMAL(8, 4),
-- 	@parmStoryLineName	VARCHAR(255),
-- 	@parmStoryArcName	VARCHAR(255),
-- 	@parmPageNumber		INT,
-- 	@parmFilePath		VARCHAR(255),
-- 	@parmPageFileName	VARCHAR(255),
-- 	@parmPageType		TINYINT
-- AS
-- BEGIN
-- 
-- 	DECLARE @IssueID INT;
-- 	DECLARE @StoryArcID INT;
-- 
-- 	PRINT ' '
-- 	PRINT 'START usp_Pages_Upsert ''' + 
-- 		@parmSeriesName + ''', ' + 
-- 		CAST(@parmIssueNumber AS VARCHAR(MAX)) + ', ''' + 
-- 		COALESCE(@parmStoryLineName, 'NULL') + ''', ''' + 
-- 		COALESCE(@parmStoryArcName, 'NULL') + ''', ' + 
-- 		CAST(@parmPageNumber AS VARCHAR(MAX)) + ', ''' + 
-- 		@parmFilePath + '''' + 
-- 		@parmPageFileName + ''', ' + 
-- 		CAST(@parmPageType AS VARCHAR(MAX))
-- 
-- 
-- 	PRINT 'Calling usp_Issues_Upsert ''' + 
-- 		@parmSeriesName + ''', ' + 
-- 		CAST(@parmIssueNumber AS VARCHAR(MAX)) + ', ''' + 
-- 		@parmFilePath + ''''
-- 
-- 	EXEC usp_Issues_Upsert
-- 		@parmSeriesName = @parmSeriesName,
-- 		@parmIssueNumber = @parmIssueNumber,
-- 		@parmFilePath = @parmFilePath,
-- 		@parmIssueID = @IssueID OUTPUT
-- 
-- 	PRINT 'IssueID Lookup Returned: ' + CAST(@IssueID AS VARCHAR(MAX))
-- 	
-- --THIS IS NEEDED???
-- --print 'debug 1'
-- 	PRINT 'Looking up Page'
-- 
-- 	IF NOT EXISTS(SELECT 1
-- 	FROM Pages
-- 	WHERE
-- 		IssueID = @IssueID
-- 		AND PageNumber = @parmPageNumber)
-- 	BEGIN
-- 
-- 		PRINT 'Issue Not Found.  INSERTING Page'
-- 
-- 		INSERT INTO Pages (
-- 			IssueID,
-- 			PageNumber,
-- 			PageFileName,
-- 			PageType,
-- 			CreationDate,
-- 			ModificationDate)
-- 		SELECT
-- 			@IssueID,
-- 			@parmPageNumber,
-- 			@parmPageFileName,
-- 			@parmPageType,
-- 			GETDATE(),
-- 			GETDATE();
-- 	END
-- 	ELSE
-- 	BEGIN
-- 
-- 		PRINT 'Issue Was Found.  UPDATING Pages'
-- 
-- 		UPDATE Pages
-- 		SET 
-- 			PageFileName = @parmPageFileName,
-- 			PageType = @parmPageType,
-- 			ModificationDate = GetDate()
-- 		WHERE
-- 			IssueID = @IssueID
-- 			AND PageNumber = @parmPageNumber
-- 	END
-- 
-- 	--IF @parmStoryLineName IS NULL AND @parmStoryArcName IS NULL
-- 	--BEGIN
-- 	--PRINT 'END usp_Pages_Upsert.  Did not Upser StoryLine/StoryArc'
-- 	--PRINT ' '
-- 	--	RETURN
-- 	--END
-- 
-- 	PRINT 'Calling usp_StoryArcs_Upsert'
-- 
-- 	EXEC usp_StoryArcs_Upsert 
-- 		@parmStoryLineName = @parmStoryLineName,
-- 		@parmStoryArcName = @parmStoryArcName,
-- 		@parmStoryArcID = @StoryArcID OUTPUT
-- 
-- 	DECLARE @PageStoryArcID INT = 0
-- 
-- 	PRINT 'Looking up PageStoryArc'
-- 	
-- 	SELECT @PageStoryArcID = PageStoryArcs.PageStoryArcID
-- 	FROM PageStoryArcs
-- 		INNER JOIN Pages ON PageStoryArcs.PageID = Pages.PageID
-- 	WHERE 
-- 		Pages.IssueID = @IssueID
-- 		AND PageNumber = @parmPageNumber
-- 
-- 	PRINT 'FOUND PageStoryArcID: ' + CAST(@PageStoryArcID AS VARCHAR(MAX))
-- 
-- 	IF @PageStoryArcID = 0
-- 	BEGIN
-- 
-- 		IF @StoryArcID IS NULL
-- 		BEGIN
-- 			PRINT 'NOT INSERTING PageStoryArc.  StoryArc was NULL'
-- 			RETURN
-- 		END
-- 
-- 		PRINT 'INSERTING PageStoryArc'
-- 
-- 		INSERT INTO PageStoryArcs (
-- 			PageID,
-- 			StoryArcID,
-- 			CreationDate,
-- 			ModificationDate)
-- 		SELECT
-- 			Pages.PageID,
-- 			@StoryArcID,
-- 			GetDAte(),
-- 			GETDATE()
-- 		FROM Pages 
-- 		WHERE 
-- 			Pages.IssueID = @IssueID
-- 			AND Pages.PageNumber = @parmPageNumber
-- 	END
-- 	ELSE
-- 	BEGIN
-- 
-- 		IF @StoryArcID IS NULL
-- 		BEGIN
-- 			PRINT 'DELETING PageStoryArc.  StoryArc was NULL'
-- 			DELETE FROM PageStoryArcs
-- 			where pageid in(
-- 			select pageid
-- 			FROM Pages 
-- 			WHERE 
-- 				Pages.IssueID = @IssueID
-- 				AND Pages.PageNumber = @parmPageNumber)
-- 			RETURN
-- 		END
-- 
-- 		PRINT 'UPDATING PageStoryArc'
-- 
-- 		update PageStoryArcs
-- 		set StoryArcID = @StoryArcID
-- 		where pageid in(
-- 		select pageid
-- 		FROM Pages 
-- 		WHERE 
-- 			Pages.IssueID = @IssueID
-- 			AND Pages.PageNumber = @parmPageNumber)
-- 	END
-- 
-- 	PRINT 'END usp_Pages_Upsert'
-- 	PRINT ' '
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_Page_UpdateStoryLine
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- CREATE  OR REPLACE PROCEDURE [dbo].[usp_Page_UpdateStoryLine]
--     @parmPageID			INT,
-- 	@parmStoryLineName	VARCHAR(255)
-- AS
-- BEGIN
-- 
-- 	DECLARE @StoryArcName VARCHAR(255)
-- 	DECLARE @StoryLineID INT
-- 	DECLARE @StoryArcID INT
-- 
-- 	EXEC usp_StoryLines_Upsert 
-- 		@parmStoryLineName = @parmStoryLineName, 
-- 		@parmStoryLineID = @storyLineID OUTPUT
-- 
-- PRINT 'StoryLine: ' + CAST(@StoryLineID AS VARCHAR(255))
-- 
-- 	SELECT @StoryArcName = StoryArcName
-- 	FROM StoryLines 
-- 		INNER JOIN StoryArcs 
-- 			INNER JOIN PageStoryArcs ON 
-- 				StoryArcs.StoryArcID = PageStoryArcs.StoryArcID ON
-- 			StoryLines.StoryLineID = StoryArcs.StoryLineID
-- 	WHERE PageStoryArcs.PageID = @parmPageID
-- 
-- PRINT 'StoryArcName: ' + @StoryArcName
-- 
-- 	EXEC usp_StoryArcs_Upsert
-- 		@parmStoryLineName = @parmStoryLineName,
-- 		@parmStoryArcName = @StoryArcName,
-- 		@parmStoryArcID = @StoryArcID OUTPUT
-- 
-- Print 'StoryArcID ' + CAST(@StoryArcID AS VARCHAR(255))
-- 
-- 	UPDATE PageStoryArcs SET StoryArcID = @StoryArcID WHERE PageID = @parmPageID
-- 
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_Pages_GetBySeries
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- CREATE  OR REPLACE PROCEDURE [dbo].[usp_Pages_GetBySeries]
--     @parmSeriesName		VARCHAR(255),
--     @parmIssueFrom			DECIMAL,
--     @parmIssueTo				DECIMAL
--     --out SortedSet<cStoryLine> storyLineList) {
-- AS
-- BEGIN
-- 	SELECT
-- 		Series.SeriesID, 
-- 		Series.SeriesName,
-- 		Issues.IssueID,
-- 		Issues.IssueNumber,
-- 		Issues.FilePath,
-- 		Pages.PageID,
-- 		Pages.PageNumber,
-- 		Pages.PageFileName,
-- 		Pages.PageType,
-- 		StoryArcs.StoryArcID,
-- 		StoryArcs.StoryArcName,
-- 		StoryArcs.LastQuickPickDate,
-- 		StoryLines.StoryLineID,
-- 		StoryLines.StoryLineName
-- 	FROM
-- 		StoryLines 
-- 			INNER JOIN StoryArcs 
-- 				INNER JOIN PageStoryArcs 
-- 					INNER JOIN Pages 
-- 						INNER JOIN Issues 
-- 							INNER JOIN Series ON
-- 								Issues.SeriesID = Series.SeriesID ON
-- 							Pages.IssueID = Issues.IssueID ON
-- 						PageStoryArcs.PageID = Pages.PageID ON
-- 					StoryArcs.StoryArcID = PageStoryArcs.StoryArcID ON
-- 				StoryLines.StoryLineID = StoryArcs.StoryLineID
-- 	WHERE
-- 		Series.SeriesName = @parmSeriesName
-- 		AND Issues.IssueNumber >= @parmIssueFrom
-- 		AND Issues.IssueNumber <= @parmIssueTo
-- 	ORDER BY 
-- 		SeriesName,
-- 		SeriesID,
-- 		StoryArcName,
-- 		StoryArcID,
-- 		IssueNumber,
-- 		IssueID,
-- 		PageNumber,
-- 		PageID
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_StoryLines_Get
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- 
-- CREATE     OR REPLACE PROCEDURE [dbo].[usp_StoryLines_Get]
--     @parmSeriesID		INT=null,
--     @parmIssueFrom		DECIMAL=null,
--     @parmIssueTo		DECIMAL=null
-- AS
-- BEGIN
-- 	SELECT 
-- 		StoryLines.StoryLineID,
-- 		StoryLines.StoryLineName
-- 	FROM Series 
-- 		INNER JOIN Issues 
-- 			INNER JOIN Pages 
-- 				INNER JOIN PageStoryArcs 
-- 					INNER JOIN StoryArcs 
-- 						INNER JOIN StoryLines ON 
-- 							StoryArcs.StoryLineID = StoryLines.StoryLineID ON 
-- 						PageStoryArcs.StoryArcID = StoryArcs.StoryArcID ON 
-- 					Pages.PageID = PageStoryArcs.PageID ON 
-- 				Issues.IssueID = Pages.IssueID ON 
-- 			Series.SeriesID = Issues.SeriesID
-- 	WHERE
-- 		Series.SeriesID = COALESCE(@parmSeriesID, Series.SeriesID)
-- 		AND Issues.IssueNumber >= COALESCE(@parmIssueFrom, Issues.IssueNumber)
-- 		AND Issues.IssueNumber <= COALESCE(@parmIssueTo, Issues.IssueNumber)
-- 	GROUP BY
-- 		StoryLines.StoryLineID,
-- 		StoryLines.StoryLineName
-- 	ORDER BY 
-- 		StoryLines.StoryLineName
-- END
-- ;

-- ----------------------------------------------------------------------------
-- View Comics.usp_Page_UpdateStoryArc
-- ----------------------------------------------------------------------------
-- USE `Comics`;
-- CREATE  OR REPLACE PROCEDURE [dbo].[usp_Page_UpdateStoryArc]
--     @parmPageID			INT,
-- 	@parmStoryLineName	VARCHAR(255),
--     @parmStoryArcName	VARCHAR(255)
-- AS
-- BEGIN
-- 
-- 	DECLARE @StoryArcID INT
-- 
-- 	--CREATE TABLE #PageInfo (
-- 	--	PageID			INT,
-- 	--	PageNumber		DECIMAL,
-- 	--	PageFileNam		VARCHAR(255),
-- 	--	IssueNumber		DECIMAL,
-- 	--	FilePath		VARCHAR(255),
-- 	--	SeriesName		VARCHAR(255),
-- 	--	StoryLineName	VARCHAR(255),
-- 	--	StoryArcName	VARCHAR(255),
-- 	--	PageType		TINYINT,
-- 	--	LastQuickPickDate	DATETIME,
-- 	--	PageStoryArcID	INT,
-- 	--	PagesModificationDate DATETIME
-- 	--)
-- 
-- 	--INSERT INTO #PageInfo
-- 	--EXEC usp_PageInfo_Get
-- 	--	@parmSeriesName = @parmSeriesName,
-- 	--	@parmIssueNumber = @parmIssueNumber,
-- 	--	@parmPageNumber = @parmPageNumber
-- 
-- 
-- 	--IF @@ROWCOUNT > 0
-- 	--BEGIN
-- 
-- 		EXEC usp_StoryArcs_Upsert 
-- 			@parmStoryLineName = @parmStoryLineName,
-- 			@parmStoryArcName = @parmStoryArcName,
-- 			@parmStoryArcID	= @StoryArcID OUTPUT
-- 
-- 		UPDATE PageStoryArcs
-- 		SET PageStoryArcs.StoryArcID = @StoryArcID, ModificationDate = GetDate()
-- 		FROM PageStoryArcs
-- --			INNER JOIN #PageInfo ON PageStoryArcs.PageID = #PageInfo.PageID
-- 		WHERE PageID = @parmPageID
-- 	--END
-- END
-- ;

-- ----------------------------------------------------------------------------
-- Routine Comics.sp_upgraddiagrams
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
-- 	CREATE PROCEDURE dbo.sp_upgraddiagrams
-- 	AS
-- 	BEGIN
-- 		IF OBJECT_ID(N'dbo.sysdiagrams') IS NOT NULL
-- 			return 0;
-- 	
-- 		CREATE TABLE dbo.sysdiagrams
-- 		(
-- 			name sysname NOT NULL,
-- 			principal_id int NOT NULL,	-- we may change it to varbinary(85)
-- 			diagram_id int PRIMARY KEY IDENTITY,
-- 			version int,
-- 	
-- 			definition varbinary(max)
-- 			CONSTRAINT UK_principal_name UNIQUE
-- 			(
-- 				principal_id,
-- 				name
-- 			)
-- 		);
-- 
-- 
-- 		/* Add this if we need to have some form of extended properties for diagrams */
-- 		/*
-- 		IF OBJECT_ID(N'dbo.sysdiagram_properties') IS NULL
-- 		BEGIN
-- 			CREATE TABLE dbo.sysdiagram_properties
-- 			(
-- 				diagram_id int,
-- 				name sysname,
-- 				value varbinary(max) NOT NULL
-- 			)
-- 		END
-- 		*/
-- 
-- 		IF OBJECT_ID(N'dbo.dtproperties') IS NOT NULL
-- 		begin
-- 			insert into dbo.sysdiagrams
-- 			(
-- 				[name],
-- 				[principal_id],
-- 				[version],
-- 				[definition]
-- 			)
-- 			select	 
-- 				convert(sysname, dgnm.[uvalue]),
-- 				DATABASE_PRINCIPAL_ID(N'dbo'),			-- will change to the sid of sa
-- 				0,							-- zero for old format, dgdef.[version],
-- 				dgdef.[lvalue]
-- 			from dbo.[dtproperties] dgnm
-- 				inner join dbo.[dtproperties] dggd on dggd.[property] = 'DtgSchemaGUID' and dggd.[objectid] = dgnm.[objectid]	
-- 				inner join dbo.[dtproperties] dgdef on dgdef.[property] = 'DtgSchemaDATA' and dgdef.[objectid] = dgnm.[objectid]
-- 				
-- 			where dgnm.[property] = 'DtgSchemaNAME' and dggd.[uvalue] like N'_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
-- 			return 2;
-- 		end
-- 		return 1;
-- 	END
-- 	$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.sp_helpdiagrams
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
-- 	CREATE PROCEDURE dbo.sp_helpdiagrams
-- 	(
-- 		@diagramname sysname = NULL,
-- 		@owner_id int = NULL
-- 	)
-- 	WITH EXECUTE AS N'dbo'
-- 	AS
-- 	BEGIN
-- 		DECLARE @user sysname
-- 		DECLARE @dboLogin bit
-- 		EXECUTE AS CALLER;
-- 			SET @user = USER_NAME();
-- 			SET @dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
-- 		REVERT;
-- 		SELECT
-- 			[Database] = DB_NAME(),
-- 			[Name] = name,
-- 			[ID] = diagram_id,
-- 			[Owner] = USER_NAME(principal_id),
-- 			[OwnerID] = principal_id
-- 		FROM
-- 			sysdiagrams
-- 		WHERE
-- 			(@dboLogin = 1 OR USER_NAME(principal_id) = @user) AND
-- 			(@diagramname IS NULL OR name = @diagramname) AND
-- 			(@owner_id IS NULL OR principal_id = @owner_id)
-- 		ORDER BY
-- 			4, 5, 1
-- 	END
-- 	$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.sp_helpdiagramdefinition
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
-- 	CREATE PROCEDURE dbo.sp_helpdiagramdefinition
-- 	(
-- 		@diagramname 	sysname,
-- 		@owner_id	int	= null 		
-- 	)
-- 	WITH EXECUTE AS N'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 
-- 		declare @theId 		int
-- 		declare @IsDbo 		int
-- 		declare @DiagId		int
-- 		declare @UIDFound	int
-- 	
-- 		if(@diagramname is null)
-- 		begin
-- 			RAISERROR (N'E_INVALIDARG', 16, 1);
-- 			return -1
-- 		end
-- 	
-- 		execute as caller;
-- 		select @theId = DATABASE_PRINCIPAL_ID();
-- 		select @IsDbo = IS_MEMBER(N'db_owner');
-- 		if(@owner_id is null)
-- 			select @owner_id = @theId;
-- 		revert; 
-- 	
-- 		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname;
-- 		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId ))
-- 		begin
-- 			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
-- 			return -3
-- 		end
-- 
-- 		select version, definition FROM dbo.sysdiagrams where diagram_id = @DiagId ; 
-- 		return 0
-- 	END
-- 	$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.sp_creatediagram
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
-- 	CREATE PROCEDURE dbo.sp_creatediagram
-- 	(
-- 		@diagramname 	sysname,
-- 		@owner_id		int	= null, 	
-- 		@version 		int,
-- 		@definition 	varbinary(max)
-- 	)
-- 	WITH EXECUTE AS 'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 	
-- 		declare @theId int
-- 		declare @retval int
-- 		declare @IsDbo	int
-- 		declare @userName sysname
-- 		if(@version is null or @diagramname is null)
-- 		begin
-- 			RAISERROR (N'E_INVALIDARG', 16, 1);
-- 			return -1
-- 		end
-- 	
-- 		execute as caller;
-- 		select @theId = DATABASE_PRINCIPAL_ID(); 
-- 		select @IsDbo = IS_MEMBER(N'db_owner');
-- 		revert; 
-- 		
-- 		if @owner_id is null
-- 		begin
-- 			select @owner_id = @theId;
-- 		end
-- 		else
-- 		begin
-- 			if @theId <> @owner_id
-- 			begin
-- 				if @IsDbo = 0
-- 				begin
-- 					RAISERROR (N'E_INVALIDARG', 16, 1);
-- 					return -1
-- 				end
-- 				select @theId = @owner_id
-- 			end
-- 		end
-- 		-- next 2 line only for test, will be removed after define name unique
-- 		if EXISTS(select diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @diagramname)
-- 		begin
-- 			RAISERROR ('The name is already used.', 16, 1);
-- 			return -2
-- 		end
-- 	
-- 		insert into dbo.sysdiagrams(name, principal_id , version, definition)
-- 				VALUES(@diagramname, @theId, @version, @definition) ;
-- 		
-- 		select @retval = @@IDENTITY 
-- 		return @retval
-- 	END
-- 	$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.sp_renamediagram
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
-- 	CREATE PROCEDURE dbo.sp_renamediagram
-- 	(
-- 		@diagramname 		sysname,
-- 		@owner_id		int	= null,
-- 		@new_diagramname	sysname
-- 	
-- 	)
-- 	WITH EXECUTE AS 'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 		declare @theId 			int
-- 		declare @IsDbo 			int
-- 		
-- 		declare @UIDFound 		int
-- 		declare @DiagId			int
-- 		declare @DiagIdTarg		int
-- 		declare @u_name			sysname
-- 		if((@diagramname is null) or (@new_diagramname is null))
-- 		begin
-- 			RAISERROR ('Invalid value', 16, 1);
-- 			return -1
-- 		end
-- 	
-- 		EXECUTE AS CALLER;
-- 		select @theId = DATABASE_PRINCIPAL_ID();
-- 		select @IsDbo = IS_MEMBER(N'db_owner'); 
-- 		if(@owner_id is null)
-- 			select @owner_id = @theId;
-- 		REVERT;
-- 	
-- 		select @u_name = USER_NAME(@owner_id)
-- 	
-- 		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
-- 		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
-- 		begin
-- 			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
-- 			return -3
-- 		end
-- 	
-- 		-- if((@u_name is not null) and (@new_diagramname = @diagramname))	-- nothing will change
-- 		--	return 0;
-- 	
-- 		if(@u_name is null)
-- 			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @new_diagramname
-- 		else
-- 			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @owner_id and name = @new_diagramname
-- 	
-- 		if((@DiagIdTarg is not null) and  @DiagId <> @DiagIdTarg)
-- 		begin
-- 			RAISERROR ('The name is already used.', 16, 1);
-- 			return -2
-- 		end		
-- 	
-- 		if(@u_name is null)
-- 			update dbo.sysdiagrams set [name] = @new_diagramname, principal_id = @theId where diagram_id = @DiagId
-- 		else
-- 			update dbo.sysdiagrams set [name] = @new_diagramname where diagram_id = @DiagId
-- 		return 0
-- 	END
-- 	$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.sp_alterdiagram
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
-- 	CREATE PROCEDURE dbo.sp_alterdiagram
-- 	(
-- 		@diagramname 	sysname,
-- 		@owner_id	int	= null,
-- 		@version 	int,
-- 		@definition 	varbinary(max)
-- 	)
-- 	WITH EXECUTE AS 'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 	
-- 		declare @theId 			int
-- 		declare @retval 		int
-- 		declare @IsDbo 			int
-- 		
-- 		declare @UIDFound 		int
-- 		declare @DiagId			int
-- 		declare @ShouldChangeUID	int
-- 	
-- 		if(@diagramname is null)
-- 		begin
-- 			RAISERROR ('Invalid ARG', 16, 1)
-- 			return -1
-- 		end
-- 	
-- 		execute as caller;
-- 		select @theId = DATABASE_PRINCIPAL_ID();	 
-- 		select @IsDbo = IS_MEMBER(N'db_owner'); 
-- 		if(@owner_id is null)
-- 			select @owner_id = @theId;
-- 		revert;
-- 	
-- 		select @ShouldChangeUID = 0
-- 		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
-- 		
-- 		if(@DiagId IS NULL or (@IsDbo = 0 and @theId <> @UIDFound))
-- 		begin
-- 			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
-- 			return -3
-- 		end
-- 	
-- 		if(@IsDbo <> 0)
-- 		begin
-- 			if(@UIDFound is null or USER_NAME(@UIDFound) is null) -- invalid principal_id
-- 			begin
-- 				select @ShouldChangeUID = 1 ;
-- 			end
-- 		end
-- 
-- 		-- update dds data			
-- 		update dbo.sysdiagrams set definition = @definition where diagram_id = @DiagId ;
-- 
-- 		-- change owner
-- 		if(@ShouldChangeUID = 1)
-- 			update dbo.sysdiagrams set principal_id = @theId where diagram_id = @DiagId ;
-- 
-- 		-- update dds version
-- 		if(@version is not null)
-- 			update dbo.sysdiagrams set version = @version where diagram_id = @DiagId ;
-- 
-- 		return 0
-- 	END
-- 	$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.sp_dropdiagram
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
-- 	CREATE PROCEDURE dbo.sp_dropdiagram
-- 	(
-- 		@diagramname 	sysname,
-- 		@owner_id	int	= null
-- 	)
-- 	WITH EXECUTE AS 'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 		declare @theId 			int
-- 		declare @IsDbo 			int
-- 		
-- 		declare @UIDFound 		int
-- 		declare @DiagId			int
-- 	
-- 		if(@diagramname is null)
-- 		begin
-- 			RAISERROR ('Invalid value', 16, 1);
-- 			return -1
-- 		end
-- 	
-- 		EXECUTE AS CALLER;
-- 		select @theId = DATABASE_PRINCIPAL_ID();
-- 		select @IsDbo = IS_MEMBER(N'db_owner'); 
-- 		if(@owner_id is null)
-- 			select @owner_id = @theId;
-- 		REVERT; 
-- 		
-- 		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
-- 		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
-- 		begin
-- 			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
-- 			return -3
-- 		end
-- 	
-- 		delete from dbo.sysdiagrams where diagram_id = @DiagId;
-- 	
-- 		return 0;
-- 	END
-- 	$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_StoryArcs_GetByStoryLine
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
-- CREATE    PROCEDURE [dbo].[usp_StoryArcs_GetByStoryLine]
-- 	@parmStoryLineName		VARCHAR(255),
-- 	@parmStoryArcName		VARCHAR(255)
-- AS
-- BEGIN
-- 	SELECT
-- 		StoryArcs.StoryArcID,
-- 		StoryArcs.StoryArcName,
-- 		StoryArcs.IsUnnamed,
-- 		StoryLines.StoryLineID,
-- 		StoryLines.StoryLineName
-- 	FROM StoryArcs
-- 		INNER JOIN StoryLines ON
-- 			StoryArcs.StoryLineID = StoryLines.StoryLineID
-- 	WHERE
-- 		StoryLines.StoryLineName = @parmStoryLineName
-- 		AND StoryArcs.StoryArcName = @parmStoryArcName
-- 	ORDER BY 
-- 		StoryLines.StoryLineName,
-- 		StoryArcs.StoryArcName
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_StoryArc_Get
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
-- CREATE    PROCEDURE [dbo].[usp_StoryArc_Get] 
-- 	@parmSeriesName		VARCHAR(255),
-- 	@parmIssueNumber	DECIMAL,
-- 	@parmPageNumber		INT
-- AS
-- BEGIN
-- 
-- 	SELECT 
-- 		StoryArcs.StoryArcID,
-- 		StoryArcs.StoryArcName,
-- 		StoryArcs.StoryLineID,
-- 		StoryArcs.LastQuickPickDate,
-- 		StoryArcs.CreationDate,
-- 		StoryArcs.ModificationDate,
-- 		StoryArcs.IsUnnamed,
-- 		StoryLines.StoryLineID,
-- 		StoryLines.StoryLineName
-- 	FROM Series
-- 		INNER JOIN Issues 
-- 			INNER JOIN Pages
-- 				INNER JOIN PageStoryArcs
-- 					INNER JOIN StoryArcs
-- 						INNER JOIN StoryLines
-- 						ON StoryArcs.StoryLineID = StoryLines.StoryLineID
-- 					ON PageStoryArcs.StoryArcID = StoryArcs.StoryArcID
-- 				ON Pages.PageID = PageStoryArcs.PageID
-- 			ON Issues.IssueID = Pages.IssueID
-- 		ON Series.SeriesID = Issues.SeriesID
-- 	WHERE
-- 		Series.SeriesName = @parmSeriesName
-- 		AND Issues.IssueNumber = @parmIssueNumber
-- 		AND Pages.PageNumber = @parmPageNumber
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_Series_GetAll
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- CREATE PROCEDURE usp_Series_GetAll
-- AS
-- BEGIN
-- 	SELECT 
-- 		Series.SeriesID,
-- 		Series.SeriesName
-- 	FROM Series
-- 	ORDER BY Series.SeriesName
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_SeriesIssues_Get
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- CREATE PROCEDURE [dbo].[usp_SeriesIssues_Get]
--     @parmSeriesName		VARCHAR(255),
--     @parmIssueFrom		DECIMAL,
--     @parmIssueTo		DECIMAL
--     --out SortedSet<cIssue> issueList) {
-- AS
-- BEGIN
-- 	SELECT 
-- 		Series.SeriesID,
-- 		Series.SeriesName,
-- 		Issues.IssueID,
-- 		Issues.IssueNumber,
-- 		Issues.FilePath
-- 	FROM Issues
-- 		INNER JOIN Series ON Issues.SeriesID = Issues.SeriesID
-- 	WHERE 
-- 		Series.SeriesName = @parmSeriesName
-- 		AND Issues.IssueNumber >= @parmIssueFrom
-- 		AND Issues.IssueNumber <= @parmIssueTo
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_SystemSettings_Get
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- -- =============================================
-- -- Author:		<Author,,Name>
-- -- Create date: <Create Date,,>
-- -- Description:	<Description,,>
-- -- =============================================
-- CREATE PROCEDURE usp_SystemSettings_Get 
-- AS
-- BEGIN
-- 	-- SET NOCOUNT ON added to prevent extra result sets from
-- 	-- interfering with SELECT statements.
-- 	SET NOCOUNT ON;
-- 
--     -- Insert statements for procedure here
-- 	SELECT * FROM SystemSettings
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_StoryLineStoryArcs_Get
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
-- CREATE    PROCEDURE [dbo].[usp_StoryLineStoryArcs_Get] 
--     @parmSeriesName		VARCHAR(255),
-- 	@parmIssueFrom		DECIMAL,
--     @parmIssueTo		DECIMAL,
--     @parmStoryLineName	VARCHAR(255)
--     --out cStoryArc[] storyArcs) {
-- AS
-- BEGIN
-- 	SELECT 
-- 		StoryArcs.StoryArcID,
-- 		StoryArcs.StoryArcName,
-- 		StoryArcs.IsUnnamed,
-- 		StoryArcs.StoryLineID,
-- 		StoryLines.StoryLineName
-- 	FROM
-- 		StoryLines 
-- 			INNER JOIN StoryArcs 
-- 				INNER JOIN PageStoryArcs 
-- 					INNER JOIN Pages 
-- 						INNER JOIN Issues 
-- 							INNER JOIN Series ON
-- 								Issues.SeriesID = Series.SeriesID ON
-- 							Pages.IssueID = Issues.IssueID ON
-- 						PageStoryArcs.PageID = Pages.PageID ON
-- 					StoryArcs.StoryArcID = PageStoryArcs.StoryArcID ON
-- 				StoryLines.StoryLineID = StoryArcs.StoryLineID
-- 	WHERE
-- 		Series.SeriesName = @parmSeriesName
-- 		AND Issues.IssueNumber >= @parmIssueFrom
-- 		AND Issues.IssueNumber <= @parmIssueTo
-- 		AND StoryLines.StoryLineName = @parmStoryLineName
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_Pages_Get
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
--  CREATE   PROCEDURE [dbo].[usp_Pages_Get]
--     @parmSeriesID		int,
--     @parmStoryLineID	int,
--     @parmIssueFrom		DECIMAL,
--     @parmIssueTo		DECIMAL
-- AS
-- BEGIN
-- 	SELECT 
-- 		PagesView.StoryLineID,
-- 		PagesView.StoryLineName,
-- 		PagesView.StoryArcName,
-- 		PagesView.StoryArcID,
-- 		PagesView.LastQuickPickDate,
-- 		PagesView.PageID,
-- 		PagesView.PageNumber,
-- 		PagesView.PageFileName,
-- 		PagesView.PageType,
-- 		PagesView.IssueID,
-- 		PagesView.IssueNumber,
-- 		PagesView.FilePath,
-- 		PagesView.SeriesID,
-- 		PagesView.SeriesName
-- 	FROM PagesView
-- 	WHERE
-- 		PagesView.SeriesID = @parmSeriesID
-- 		AND PagesView.StoryLineID = COALESCE(@parmStoryLineID, PagesView.StoryLineID)
-- 		AND PagesView.IssueNumber >= COALESCE(@parmIssueFrom, PagesView.IssueNumber)
-- 		AND PagesView.IssueNumber <= COALESCE(@parmIssueTo, PagesView.IssueNumber)
-- 	ORDER BY 
-- 		PagesView.SeriesName,
-- 		PagesView.StoryLineName,
-- 		PagesView.StoryArcName,
-- 		PagesView.IssueNumber,
-- 		PagesView.PageNumber
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_StoryArc_UpdateLastQuickPickDate
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- CREATE PROCEDURE usp_StoryArc_UpdateLastQuickPickDate
-- --    @parmSeriesName			VARCHAR(255),
-- 	@parmStoryLineName		VARCHAR(255),
-- 	@parmStoryArcName		VARCHAR(255),
--     @parmLastQuickPickDate	DATETIME
-- AS
-- BEGIN
-- 
-- 	DECLARE @StoryArcID INT
-- 
-- 	IF EXISTS(
-- 		SELECT 1
-- 		FROM StoryLines
-- 			INNER JOIN StoryArcs ON StoryLines.StoryLineID = StoryArcs.StoryLineID
-- 		WHERE
-- 			StoryLines.StoryLineName = @parmStoryLineName
-- 			AND StoryArcs.StoryArcName = @parmStoryArcName)
-- 	
-- 	BEGIN
-- 		UPDATE StoryArcs
-- 		SET StoryArcs.LastQuickPickDate = @parmLastQuickPickDate
-- 		WHERE StoryArcID IN (
-- 			SELECT StoryArcID
-- 			FROM StoryLines
-- 				INNER JOIN StoryArcs ON StoryLines.StoryLineID = StoryArcs.StoryLineID
-- 			WHERE
-- 				StoryLines.StoryLineName = @parmStoryLineName
-- 				AND StoryArcs.StoryArcName = @parmStoryArcName
-- 		)
-- 	END
-- 
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_Issue_UpdateFileName
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- CREATE PROCEDURE usp_Issue_UpdateFileName
-- 	@parmOriginalFilePath	VARCHAR(255),
-- 	@parmNewFilePath		VARCHAR(255)
-- AS
-- 
-- BEGIN
-- 
-- 	UPDATE Issues
-- 	SET Issues.FilePath = @parmNewFilePath
-- 	WHERE Issues.FilePath = @parmOriginalFilePath;
-- 
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_Issues_Get
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
--  CREATE   PROCEDURE [dbo].[usp_Issues_Get]
--     @parmSeriesID		INT=NULL,
--     @parmStoryLineID	INT=NULL,
--     @parmIssueFrom		DECIMAL=NULL,
--     @parmIssueTo		DECIMAL=NULL
-- AS
-- BEGIN
-- 
-- 	SELECT 
-- 		Issues.IssueID,
-- 		Issues.IssueNumber,
-- 		Issues.FilePath,
-- 		Series.SeriesID,
-- 		Series.SeriesName
-- 	FROM Series INNER JOIN 
-- 		Issues INNER JOIN Pages 
-- 			INNER JOIN PageStoryArcs 
-- 				INNER JOIN StoryArcs 
-- 					INNER JOIN StoryLines ON 
-- 						StoryArcs.StoryLineID = StoryLines.StoryLineID ON
-- 					PageStoryArcs.StoryArcID = StoryArcs.StoryArcID ON
-- 				Pages.PageID = PageStoryArcs.PageID ON
-- 			Issues.IssueID = Pages.IssueID ON
-- 		Series.SeriesID = Issues.SeriesID
-- 	WHERE 
-- 		Series.SeriesID = COALESCE(@parmSeriesID, Series.SeriesID)
-- 		AND StoryLines.StoryLineID = COALESCE(CASE WHEN @parmStoryLineID <= 0 THEN StoryLines.StoryLineID ELSE @parmStoryLineID END, StoryLines.StoryLineID)
-- 		AND Issues.IssueNumber >= COALESCE(@parmIssueFrom, Issues.IssueNumber)
-- 		AND Issues.IssueNumber <= COALESCE(@parmIssueTo, Issues.IssueNumber)
-- 	GROUP BY
-- 		Series.SeriesID,
-- 		Series.SeriesName,
-- 		Issues.IssueID,
-- 		Issues.IssueNumber,
-- 		Issues.FilePath
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_PageImage_GetByIssue
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- CREATE PROCEDURE usp_PageImage_GetByIssue
--     @parmPageIndex		INT
--     --out cIssue issue) {
-- AS
-- BEGIN
-- 
-- --print '@parmIssueNumber = ' + CAST(@parmIssueNumber AS VARCHAR(20))
-- 
-- 	SELECT 
-- 		PageImages.PageImageID,
-- 		Images.ImageID,
-- 		Images.ImageData
-- 	FROM PageImages 
-- 	INNER JOIN Images ON 
-- 	PageImages.imageid = Images.ImageID
-- 	WHERE 
-- 		pageimages.PageID = @parmPageIndex
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_LibraryFolders_Get
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
-- CREATE PROCEDURE usp_LibraryFolders_Get 
-- AS
-- BEGIN
-- 	SELECT * FROM LibraryFolders
-- 	ORDER BY LibraryFolders.LibraryFolderPath
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_LibraryFolders_Create
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
-- CREATE PROCEDURE usp_LibraryFolders_Create
-- 	@parmLibraryFolderPath			VARCHAR(255),
-- 	@parmLibraryFolderDescription	VARCHAR(255)
-- AS
-- BEGIN
-- 	INSERT INTO LibraryFolders (
-- 		LibraryFolderPath,
-- 		LibraryFolderDescription
-- 	)
-- 	VALUES (
-- 		@parmLibraryFolderPath,
-- 		@parmLibraryFolderDescription
-- 	)
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_LibraryFolders_Update
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
-- CREATE PROCEDURE usp_LibraryFolders_Update
-- 	@parmLibraryFolderID			INT,
-- 	@parmLibraryFolderDescription	VARCHAR(255)
-- AS
-- BEGIN
-- 	UPDATE LibraryFolders
-- 	SET LibraryFolders.LibraryFolderDescription = @parmLibraryFolderDescription
-- 	WHERE LibraryFolders.LibraryFolderID = @parmLibraryFolderID
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_PageImage_Create
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- CREATE PROCEDURE usp_PageImage_Create
--     @parmPageIndex		INT,
-- 	@parmPageBytes		VARBINARY(MAX)
-- AS
-- BEGIN
-- 
-- INSERT INTO Images (imageData)
-- VALUES(@parmPageBytes)
-- 
-- INSERT INTO PageImages (PageID, ImageID, ImageBytes)
-- VALUES(@parmPageIndex, @@IDENTITY, @parmPageBytes)
-- 
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_PageInfo_GetById
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- CREATE PROCEDURE [dbo].[usp_PageInfo_GetById]
--     @parmPageId		INT
-- AS
-- BEGIN
-- 
-- 	SELECT
-- 		PagesView.SeriesID,
-- 		PagesView.SeriesName,
-- 		PagesView.StoryLineID,
-- 		PagesView.StoryLineName,
-- 		PagesView.PageStoryArcID,
-- 		PagesView.StoryArcID,
-- 		PagesView.StoryArcName,
-- 		PagesView.LastQuickPickDate,
-- 		PagesView.IssueID,
-- 		PagesView.IssueNumber,
-- 		PagesView.FilePath,
-- 		PagesView.PageID,
-- 		PagesView.PageNumber,
-- 		PagesView.PageFileName,
-- 		PagesView.PageType,
-- --		Pages.StoryArcID,
-- --		Pages.PageType,
-- 		PagesView.PagesModificationDate
-- 	FROM PagesView
-- 	WHERE
-- 		PagesView.PageID = @parmPageId
-- 	ORDER BY
-- 		PagesView.StoryArcsModificationDate DESC,
-- 		PagesView.SeriesName,
-- 		PagesView.IssueNumber,
-- 		PagesView.PageNumber
-- 
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_Issues_Upsert
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
--  CREATE   PROCEDURE [dbo].[usp_Issues_Upsert] 
-- 	@parmSeriesName		varchar(255),
-- 	@parmIssueNumber	decimal(8, 4),
-- 	@parmFilePath		varchar(255),
-- 	@parmIssueID		int OUTPUT
-- AS
-- 
-- BEGIN
-- 
-- 	DECLARE @SeriesID int = -1
-- 
-- 	PRINT ' '
-- 	PRINT 'START usp_Issues_Upsert ''' + 
-- 		@parmSeriesName + ''', ' + 
-- 		CAST(@parmIssueNumber AS VARCHAR(MAX)) + ', ''' + 
-- 		@parmFilePath + ''''
-- 
-- 	SELECT @parmIssueID = IssueID
-- 	FROM Issues 
-- 		INNER JOIN Series ON Issues.SeriesID = Series.SeriesID
-- 	WHERE Series.SeriesName = @parmSeriesName
-- 		AND Issues.IssueNumber = @parmIssueNumber
-- 
-- 	IF @parmIssueID IS NULL OR @parmIssueID < 0
-- 	BEGIN
-- 
-- 	PRINT 'Issue was not found.  Calling usp_Series_Upsert ''' + @parmSeriesName + '''' 
-- 	EXEC usp_Series_Upsert
-- 		@parmSeriesName	= @parmSeriesName,
-- 		@parmSeriesID = @SeriesID OUTPUT
-- 
-- 	PRINT 'INSERTING Into Issues' 
-- 		INSERT INTO Issues(SeriesID, IssueNumber, FilePath)
-- 		SELECT @SeriesID, @parmIssueNumber, @parmFilePath
-- 
-- 	PRINT 'Retrieving IssueID' 
-- 		SELECT @parmIssueID = IssueID
-- 		FROM Issues
-- 		WHERE 
-- 			Issues.SeriesID = @SeriesID
-- 			AND Issues.IssueNumber = @parmIssueNumber
-- 	PRINT 'Found IssueID ' + CAST(@parmIssueID AS VARCHAR(MAX)) 
-- 
-- 	END
-- 	ELSE
-- 	BEGIN
-- 
-- 		PRINT 'Issue was found.  UPDATING Issue (FilePath = ''' + @parmFilePath + ''') WHERE IssueID = ' + CAST(@parmIssueID AS VARCHAR(MAX))
-- 
-- 		UPDATE Issues
-- 		SET FilePath = @parmFilePath
-- 		WHERE IssueID = @parmIssueID
-- 
-- 	END
-- 
-- 	PRINT 'END usp_Issues_Upsert'
-- 	PRINT ' '
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_PageInfo_GetByIssue
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- CREATE PROCEDURE [dbo].[usp_PageInfo_GetByIssue]
--     @parmIssueId		INT
-- AS
-- BEGIN
-- 
-- 	SELECT
-- 		PagesView.SeriesID,
-- 		PagesView.SeriesName,
-- 		PagesView.StoryLineID,
-- 		PagesView.StoryLineName,
-- 		PagesView.PageStoryArcID,
-- 		PagesView.StoryArcID,
-- 		PagesView.StoryArcName,
-- 		PagesView.LastQuickPickDate,
-- 		PagesView.IssueID,
-- 		PagesView.IssueNumber,
-- 		PagesView.FilePath,
-- 		PagesView.PageID,
-- 		PagesView.PageNumber,
-- 		PagesView.PageFileName,
-- 		PagesView.PageType,
-- --		Pages.StoryArcID,
-- --		Pages.PageType,
-- 		PagesView.PagesModificationDate
-- 	FROM PagesView
-- 	WHERE
-- 		PagesView.IssueID = @parmIssueId
-- 	ORDER BY
-- 		PagesView.StoryArcsModificationDate DESC,
-- 		PagesView.SeriesName,
-- 		PagesView.IssueNumber,
-- 		PagesView.PageNumber
-- 
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_Pages_GetByIssue
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- CREATE PROCEDURE [dbo].[usp_Pages_GetByIssue]
-- 	@parmSeriesID		INT,
-- 	@parmIssueNumber	DECIMAL(8, 4)
-- AS
-- BEGIN
-- 
-- 	SELECT
-- 		PagesView.StoryLineID,
-- 		PagesView.StoryLineName,
-- 		PagesView.StoryArcID,
-- 		PagesView.StoryArcName,
-- 		PagesView.LastQuickPickDate,
-- 		PagesView.PageID,
-- 		PagesView.PageNumber,
-- 		PagesView.PageFileName,
-- 		PagesView.PageType,
-- 		PagesView.IssueID,
-- 		PagesView.IssueNumber,
-- 		PagesView.FilePath,
-- 		PagesView.SeriesID,
-- 		PagesView.SeriesName
-- 	FROM PagesView
-- 	WHERE
-- 		PagesView.SeriesID = @parmSeriesID
-- 		AND PagesView.IssueNumber = @parmIssueNumber
-- 	ORDER BY
-- 		PagesView.SeriesName,
-- 		PagesView.IssueNumber,
-- 		PagesView.PageNumber
-- 
-- 
-- 	/*SELECT
-- 		StoryLines.StoryLineName,
-- 		StoryArcs.StoryArcName,
-- 		Pages.PageID,
-- 		Pages.PageNumber,
-- 		Pages.PageFileName,
-- 		Pages.PageType,
-- 		Issues.IssueNumber,
-- 		Issues.FilePath,
-- 		Series.SeriesName
-- 	FROM
-- 		StoryLines 
-- 			INNER JOIN StoryArcs 
-- 				INNER JOIN PageStoryArcs 
-- 					INNER JOIN Pages 
-- 						INNER JOIN Issues 
-- 							INNER JOIN Series ON
-- 								Issues.SeriesID = Series.SeriesID ON
-- 							Pages.IssueID = Issues.IssueID ON
-- 						PageStoryArcs.PageID = Pages.PageID ON
-- 					StoryArcs.StoryArcID = PageStoryArcs.StoryArcID ON
-- 				StoryLines.StoryLineID = StoryArcs.StoryLineID
-- 	WHERE
-- 		Series.SeriesName = @parmSeriesName
-- 		AND Issues.IssueNumber = @parmIssueNumber
-- 	ORDER BY
-- 		Series.SeriesName,
-- 		Issues.IssueNumber,
-- 		Pages.PageNumber*/
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_Pages_GetByIssueId
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- CREATE PROCEDURE [dbo].[usp_Pages_GetByIssueId]
-- 	@parmIssueId		INT
-- AS
-- BEGIN
-- 
-- 	SELECT
-- 		PagesView.StoryLineID,
-- 		PagesView.StoryLineName,
-- 		PagesView.StoryArcID,
-- 		PagesView.StoryArcName,
-- 		PagesView.LastQuickPickDate,
-- 		PagesView.PageID,
-- 		PagesView.PageNumber,
-- 		PagesView.PageFileName,
-- 		PagesView.PageType,
-- 		PagesView.IssueID,
-- 		PagesView.IssueNumber,
-- 		PagesView.FilePath,
-- 		PagesView.SeriesID,
-- 		PagesView.SeriesName
-- 	FROM PagesView
-- 	WHERE
-- 		PagesView.IssueID = @parmIssueId
-- 	ORDER BY
-- 		PagesView.SeriesName,
-- 		PagesView.IssueNumber,
-- 		PagesView.PageNumber
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_PageInfo_Get
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- CREATE PROCEDURE [dbo].[usp_PageInfo_Get]
--     @parmSeriesName		VARCHAR(255),
--     @parmIssueNumber	DECIMAL(8, 4),
--     @parmPageNumber		INT
--     --out cPageInfo pageInfo) {
-- AS
-- BEGIN
-- 
-- 	SELECT
-- 		PagesView.SeriesID,
-- 		PagesView.SeriesName,
-- 		PagesView.StoryLineID,
-- 		PagesView.StoryLineName,
-- 		PagesView.PageStoryArcID,
-- 		PagesView.StoryArcID,
-- 		PagesView.StoryArcName,
-- 		PagesView.LastQuickPickDate,
-- 		PagesView.IssueID,
-- 		PagesView.IssueNumber,
-- 		PagesView.FilePath,
-- 		PagesView.PageID,
-- 		PagesView.PageNumber,
-- 		PagesView.PageFileName,
-- 		PagesView.PageType,
-- --		Pages.StoryArcID,
-- --		Pages.PageType,
-- 		PagesView.PagesModificationDate
-- 	FROM PagesView
-- 	WHERE
-- 		PagesView.SeriesName = @parmSeriesName
-- 		AND PagesView.IssueNumber = @parmIssueNumber
-- 		AND PagesView.PageNumber = @parmPageNumber
-- 	ORDER BY
-- 		PagesView.StoryArcsModificationDate DESC,
-- 		PagesView.SeriesName,
-- 		PagesView.IssueNumber,
-- 		PagesView.PageNumber
-- 
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_Issue_GetByPage
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- CREATE PROCEDURE [dbo].[usp_Issue_GetByPage]
--     @parmSeriesName		VARCHAR(255),
--     @parmIssueNumber	DECIMAL(8, 4)
--     --out cIssue issue) {
-- AS
-- BEGIN
-- 
-- --print '@parmIssueNumber = ' + CAST(@parmIssueNumber AS VARCHAR(20))
-- 
-- 	SELECT 
-- 		Issues.IssueID,
-- 		Issues.IssueNumber,
-- 		Issues.FilePath,
-- 		Issues.SeriesID,
-- 		Series.SeriesName
-- 	FROM Issues
-- 		INNER JOIN Series ON Issues.SeriesID = Series.SeriesID
-- 	WHERE 
-- 		Series.SeriesName = @parmSeriesName
-- 		AND Issues.IssueNumber = @parmIssueNumber
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_Issue_GetByFilePath
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- CREATE PROCEDURE usp_Issue_GetByFilePath
--     @parmFilePath	VARCHAR(255)
-- AS
-- BEGIN
-- 
-- 	SELECT 
-- 		Issues.IssueID,
-- 		Issues.IssueNumber,
-- 		Issues.FilePath,
-- 		Issues.SeriesID,
-- 		Series.SeriesName
-- 	FROM Issues
-- 		INNER JOIN Series ON Issues.SeriesID = Issues.SeriesID
-- 	WHERE 
-- 		Issues.FilePath = @parmFilePath
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_StoryArcs_Get
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
-- CREATE   PROCEDURE [dbo].[usp_StoryArcs_Get]
-- AS
-- BEGIN
-- 	SELECT TOP 20
-- 		StoryArcs.StoryArcID,
-- 		StoryArcs.StoryArcName,
-- 		StoryArcs.IsUnnamed,
-- 		StoryArcs.LastQuickPickDate,
-- 		StoryLines.StoryLineID,
-- 		StoryLines.StoryLineName
-- 	FROM StoryLines 
-- 		INNER JOIN StoryArcs
-- --			INNER JOIN PageStoryArcs 
-- 				--INNER JOIN Pages 
-- 				--	INNER JOIN Issues 
-- 				--		INNER JOIN Series ON Issues.SeriesID = Series.SeriesID ON 
-- 				--		Pages.IssueID = Pages.IssueID ON 
-- 				--	PageStoryArcs.PageID = Pages.PageID 
-- --				ON 
-- --				StoryArcs.StoryArcID = PageStoryArcs.StoryArcID 
-- ON
-- 			StoryLines.StoryLineID = StoryArcs.StoryLineID
-- 	WHERE (StoryLines.StoryLineName IS NOT NULL AND LEN(RTRIM(StoryLines.StoryLineName)) > 0) 
-- 		   OR 
-- 		  (StoryArcs.StoryArcName IS NOT NULL AND LEN(RTRIM(StoryArcs.StoryArcName)) > 0)
-- 	ORDER BY 
-- 		StoryArcs.LastQuickPickDate DESC,
-- 		StoryLines.StoryLineName,
-- 		StoryArcs.StoryArcName
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_StoryArcs_Upsert
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
-- CREATE    PROCEDURE [dbo].[usp_StoryArcs_Upsert] 
-- 	@parmStoryLineName	varchar(255),
-- 	@parmStoryArcName	varchar(255),
-- 	@parmStoryArcID		int OUTPUT
-- AS
-- 
-- BEGIN
-- 
-- 	PRINT ' '
-- 	PRINT 'START usp_StoryArcs_Upsert ''' + 
-- 		COALESCE(@parmStoryLineName, 'NULL') + ''', ''' + 
-- 		COALESCE(@parmStoryArcName, 'NULL') + ''''
-- 
-- 	DECLARE @StoryLineID int
-- 
-- 	SELECT @parmStoryArcID = StoryArcID
-- 	FROM StoryArcs
-- 		INNER JOIN StoryLines ON StoryArcs.StoryLineID = StoryLines.StoryLineID
-- 	WHERE StoryLines.StoryLineName = @parmStoryLineName
-- 		AND StoryArcs.StoryArcName = @parmStoryArcName
-- 
-- 
-- 	IF @parmStoryArcID IS NULL
-- 	BEGIN
-- 	PRINT 'Calling usp_Storylines_Upsert'
-- 
-- 	EXEC usp_Storylines_Upsert
-- 		@parmStoryLineName	= @parmStoryLineName,
-- 		@parmStoryLineID = @StoryLineID OUTPUT
-- 
-- 	IF @StoryLineID IS NULL
-- 	BEGIN
-- 		PRINT 'END usp_StoryArcs_Upsert; Exiting after Storyline Upsert returned NULL StoryLineID' 
-- 		PRINT ' '
-- 
-- 		RETURN;
-- 	END
-- 
-- 	PRINT 'INSERTING Into StoryArcs'
-- 		INSERT INTO StoryArcs(StoryLineID, StoryArcName, IsUnnamed, LastQuickPickDate, CreationDate, ModificationDate)
-- 		SELECT @StoryLineID, COALESCE(@parmStoryArcName,''), CASE WHEN @parmStoryArcName IS NULL THEN 1 WHEN LEN(@parmStoryArcName) = 0 THEN 1 ELSE 0 END, GETDATE(), GetDAte(), GetDAte()
-- 
-- 	PRINT 'Looking up StoryArcID'
-- 		SELECT @parmStoryArcID = StoryArcID
-- 		FROM StoryArcs
-- 		WHERE 
-- 			StoryArcs.StoryLineID = @StoryLineID
-- 			AND StoryArcs.StoryArcName = COALESCE(@parmStoryArcName,'')
-- 	END
-- 	ELSE
-- 	BEGIN
-- 
-- 		PRINT 'FOUND StoryArcID: ' + CAST(@parmStoryArcID AS VARCHAR(MAX))
-- 
-- 		PRINT 'UPDATING StoryArc'
-- 
-- 		UPDATE StoryArcs SET LastQuickPickDate = GetDate(), ModificationDate = GetDate()
-- 		FROM StoryArcs
-- 			INNER JOIN StoryLines ON StoryArcs.StoryLineID = StoryLines.StoryLineID
-- 		WHERE StoryLines.StoryLineName = @parmStoryLineName
-- 			AND StoryArcs.StoryArcName = COALESCE(@parmStoryArcName,'')
-- 
-- 	END
-- 
-- 	PRINT 'END usp_StoryArcs_Upsert' 
-- 	PRINT ' '
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_Series_Upsert
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
-- CREATE    PROCEDURE [dbo].[usp_Series_Upsert]
-- 	@parmSeriesName	varchar(255),
-- 	@parmSeriesID	int OUTPUT
-- AS
-- BEGIN
-- 
-- 	PRINT ' '
-- 	PRINT 'START usp_Series_Upsert ''' + 
-- 		@parmSeriesName + ''', ' + 
-- 		CAST(@parmSeriesID AS VARCHAR(MAX)) 
-- 
-- 	PRINT 'LOOKING UP SeriesID'
-- 	SELECT @parmSeriesID = SeriesID
-- 	FROM Series
-- 	WHERE Series.SeriesName = @parmSeriesName
-- 
-- 	IF @@ROWCOUNT = 0
-- 	BEGIN
-- 
-- 		PRINT 'Did not find Series.  INSERTING'
-- 
-- 		INSERT INTO Series (SeriesName)
-- 		SELECT @parmSeriesName
-- 
-- 		PRINT 'Looking Up Series'
-- 		SELECT @parmSeriesID = SeriesID
-- 		FROM Series
-- 		WHERE Series.SeriesName = @parmSeriesName
-- 	END
-- 
-- 	PRINT 'END usp_Series_Upsert'
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_Storylines_Upsert
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
-- CREATE    PROCEDURE [dbo].[usp_Storylines_Upsert]
-- 	@parmStoryLineName	varchar(255),
-- 	@parmStoryLineID	int OUTPUT
-- AS
-- BEGIN
-- 	PRINT ' '
-- 	PRINT 'START usp_Storylines_Upsert ''' + 
-- 		COALESCE(@parmStoryLineName, 'NULL') + ''''
-- 
-- 	if @parmStoryLineName IS NULL
-- 	BEGIN
-- 		PRINT 'END usp_Storylines_Upsert; Not inserting NULL StoryLine' 
-- 		PRINT ' ' 
-- 
-- 		RETURN;
-- 	END
-- 
-- 	SELECT @parmStoryLineID = StoryLineID
-- 	FROM StoryLines
-- 	WHERE StoryLines.StoryLineName = @parmStoryLineName
-- 
-- 	IF @@ROWCOUNT = 0
-- 	BEGIN
-- 		INSERT INTO StoryLines (StoryLineName)
-- 		SELECT @parmStoryLineName
-- 
-- 		SELECT @parmStoryLineID = StoryLineID
-- 		FROM StoryLines
-- 		WHERE StoryLines.StoryLineName = @parmStoryLineName
-- 	END
-- 
-- 	PRINT 'END usp_Storylines_Upsert' 
-- 	PRINT ' ' 
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_Pages_Upsert
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
--  CREATE   PROCEDURE [dbo].[usp_Pages_Upsert]
-- 	@parmSeriesName		VARCHAR(255),
-- 	@parmIssueNumber	DECIMAL(8, 4),
-- 	@parmStoryLineName	VARCHAR(255),
-- 	@parmStoryArcName	VARCHAR(255),
-- 	@parmPageNumber		INT,
-- 	@parmFilePath		VARCHAR(255),
-- 	@parmPageFileName	VARCHAR(255),
-- 	@parmPageType		TINYINT
-- AS
-- BEGIN
-- 
-- 	DECLARE @IssueID INT;
-- 	DECLARE @StoryArcID INT;
-- 
-- 	PRINT ' '
-- 	PRINT 'START usp_Pages_Upsert ''' + 
-- 		@parmSeriesName + ''', ' + 
-- 		CAST(@parmIssueNumber AS VARCHAR(MAX)) + ', ''' + 
-- 		COALESCE(@parmStoryLineName, 'NULL') + ''', ''' + 
-- 		COALESCE(@parmStoryArcName, 'NULL') + ''', ' + 
-- 		CAST(@parmPageNumber AS VARCHAR(MAX)) + ', ''' + 
-- 		@parmFilePath + '''' + 
-- 		@parmPageFileName + ''', ' + 
-- 		CAST(@parmPageType AS VARCHAR(MAX))
-- 
-- 
-- 	PRINT 'Calling usp_Issues_Upsert ''' + 
-- 		@parmSeriesName + ''', ' + 
-- 		CAST(@parmIssueNumber AS VARCHAR(MAX)) + ', ''' + 
-- 		@parmFilePath + ''''
-- 
-- 	EXEC usp_Issues_Upsert
-- 		@parmSeriesName = @parmSeriesName,
-- 		@parmIssueNumber = @parmIssueNumber,
-- 		@parmFilePath = @parmFilePath,
-- 		@parmIssueID = @IssueID OUTPUT
-- 
-- 	PRINT 'IssueID Lookup Returned: ' + CAST(@IssueID AS VARCHAR(MAX))
-- 	
-- --THIS IS NEEDED???
-- --print 'debug 1'
-- 	PRINT 'Looking up Page'
-- 
-- 	IF NOT EXISTS(SELECT 1
-- 	FROM Pages
-- 	WHERE
-- 		IssueID = @IssueID
-- 		AND PageNumber = @parmPageNumber)
-- 	BEGIN
-- 
-- 		PRINT 'Issue Not Found.  INSERTING Page'
-- 
-- 		INSERT INTO Pages (
-- 			IssueID,
-- 			PageNumber,
-- 			PageFileName,
-- 			PageType,
-- 			CreationDate,
-- 			ModificationDate)
-- 		SELECT
-- 			@IssueID,
-- 			@parmPageNumber,
-- 			@parmPageFileName,
-- 			@parmPageType,
-- 			GETDATE(),
-- 			GETDATE();
-- 	END
-- 	ELSE
-- 	BEGIN
-- 
-- 		PRINT 'Issue Was Found.  UPDATING Pages'
-- 
-- 		UPDATE Pages
-- 		SET 
-- 			PageFileName = @parmPageFileName,
-- 			PageType = @parmPageType,
-- 			ModificationDate = GetDate()
-- 		WHERE
-- 			IssueID = @IssueID
-- 			AND PageNumber = @parmPageNumber
-- 	END
-- 
-- 	--IF @parmStoryLineName IS NULL AND @parmStoryArcName IS NULL
-- 	--BEGIN
-- 	--PRINT 'END usp_Pages_Upsert.  Did not Upser StoryLine/StoryArc'
-- 	--PRINT ' '
-- 	--	RETURN
-- 	--END
-- 
-- 	PRINT 'Calling usp_StoryArcs_Upsert'
-- 
-- 	EXEC usp_StoryArcs_Upsert 
-- 		@parmStoryLineName = @parmStoryLineName,
-- 		@parmStoryArcName = @parmStoryArcName,
-- 		@parmStoryArcID = @StoryArcID OUTPUT
-- 
-- 	DECLARE @PageStoryArcID INT = 0
-- 
-- 	PRINT 'Looking up PageStoryArc'
-- 	
-- 	SELECT @PageStoryArcID = PageStoryArcs.PageStoryArcID
-- 	FROM PageStoryArcs
-- 		INNER JOIN Pages ON PageStoryArcs.PageID = Pages.PageID
-- 	WHERE 
-- 		Pages.IssueID = @IssueID
-- 		AND PageNumber = @parmPageNumber
-- 
-- 	PRINT 'FOUND PageStoryArcID: ' + CAST(@PageStoryArcID AS VARCHAR(MAX))
-- 
-- 	IF @PageStoryArcID = 0
-- 	BEGIN
-- 
-- 		IF @StoryArcID IS NULL
-- 		BEGIN
-- 			PRINT 'NOT INSERTING PageStoryArc.  StoryArc was NULL'
-- 			RETURN
-- 		END
-- 
-- 		PRINT 'INSERTING PageStoryArc'
-- 
-- 		INSERT INTO PageStoryArcs (
-- 			PageID,
-- 			StoryArcID,
-- 			CreationDate,
-- 			ModificationDate)
-- 		SELECT
-- 			Pages.PageID,
-- 			@StoryArcID,
-- 			GetDAte(),
-- 			GETDATE()
-- 		FROM Pages 
-- 		WHERE 
-- 			Pages.IssueID = @IssueID
-- 			AND Pages.PageNumber = @parmPageNumber
-- 	END
-- 	ELSE
-- 	BEGIN
-- 
-- 		IF @StoryArcID IS NULL
-- 		BEGIN
-- 			PRINT 'DELETING PageStoryArc.  StoryArc was NULL'
-- 			DELETE FROM PageStoryArcs
-- 			where pageid in(
-- 			select pageid
-- 			FROM Pages 
-- 			WHERE 
-- 				Pages.IssueID = @IssueID
-- 				AND Pages.PageNumber = @parmPageNumber)
-- 			RETURN
-- 		END
-- 
-- 		PRINT 'UPDATING PageStoryArc'
-- 
-- 		update PageStoryArcs
-- 		set StoryArcID = @StoryArcID
-- 		where pageid in(
-- 		select pageid
-- 		FROM Pages 
-- 		WHERE 
-- 			Pages.IssueID = @IssueID
-- 			AND Pages.PageNumber = @parmPageNumber)
-- 	END
-- 
-- 	PRINT 'END usp_Pages_Upsert'
-- 	PRINT ' '
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_Page_UpdateStoryLine
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- CREATE PROCEDURE [dbo].[usp_Page_UpdateStoryLine]
--     @parmPageID			INT,
-- 	@parmStoryLineName	VARCHAR(255)
-- AS
-- BEGIN
-- 
-- 	DECLARE @StoryArcName VARCHAR(255)
-- 	DECLARE @StoryLineID INT
-- 	DECLARE @StoryArcID INT
-- 
-- 	EXEC usp_StoryLines_Upsert 
-- 		@parmStoryLineName = @parmStoryLineName, 
-- 		@parmStoryLineID = @storyLineID OUTPUT
-- 
-- PRINT 'StoryLine: ' + CAST(@StoryLineID AS VARCHAR(255))
-- 
-- 	SELECT @StoryArcName = StoryArcName
-- 	FROM StoryLines 
-- 		INNER JOIN StoryArcs 
-- 			INNER JOIN PageStoryArcs ON 
-- 				StoryArcs.StoryArcID = PageStoryArcs.StoryArcID ON
-- 			StoryLines.StoryLineID = StoryArcs.StoryLineID
-- 	WHERE PageStoryArcs.PageID = @parmPageID
-- 
-- PRINT 'StoryArcName: ' + @StoryArcName
-- 
-- 	EXEC usp_StoryArcs_Upsert
-- 		@parmStoryLineName = @parmStoryLineName,
-- 		@parmStoryArcName = @StoryArcName,
-- 		@parmStoryArcID = @StoryArcID OUTPUT
-- 
-- Print 'StoryArcID ' + CAST(@StoryArcID AS VARCHAR(255))
-- 
-- 	UPDATE PageStoryArcs SET StoryArcID = @StoryArcID WHERE PageID = @parmPageID
-- 
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_Pages_GetBySeries
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- CREATE PROCEDURE [dbo].[usp_Pages_GetBySeries]
--     @parmSeriesName		VARCHAR(255),
--     @parmIssueFrom			DECIMAL,
--     @parmIssueTo				DECIMAL
--     --out SortedSet<cStoryLine> storyLineList) {
-- AS
-- BEGIN
-- 	SELECT
-- 		Series.SeriesID, 
-- 		Series.SeriesName,
-- 		Issues.IssueID,
-- 		Issues.IssueNumber,
-- 		Issues.FilePath,
-- 		Pages.PageID,
-- 		Pages.PageNumber,
-- 		Pages.PageFileName,
-- 		Pages.PageType,
-- 		StoryArcs.StoryArcID,
-- 		StoryArcs.StoryArcName,
-- 		StoryArcs.LastQuickPickDate,
-- 		StoryLines.StoryLineID,
-- 		StoryLines.StoryLineName
-- 	FROM
-- 		StoryLines 
-- 			INNER JOIN StoryArcs 
-- 				INNER JOIN PageStoryArcs 
-- 					INNER JOIN Pages 
-- 						INNER JOIN Issues 
-- 							INNER JOIN Series ON
-- 								Issues.SeriesID = Series.SeriesID ON
-- 							Pages.IssueID = Issues.IssueID ON
-- 						PageStoryArcs.PageID = Pages.PageID ON
-- 					StoryArcs.StoryArcID = PageStoryArcs.StoryArcID ON
-- 				StoryLines.StoryLineID = StoryArcs.StoryLineID
-- 	WHERE
-- 		Series.SeriesName = @parmSeriesName
-- 		AND Issues.IssueNumber >= @parmIssueFrom
-- 		AND Issues.IssueNumber <= @parmIssueTo
-- 	ORDER BY 
-- 		SeriesName,
-- 		SeriesID,
-- 		StoryArcName,
-- 		StoryArcID,
-- 		IssueNumber,
-- 		IssueID,
-- 		PageNumber,
-- 		PageID
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_StoryLines_Get
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
-- CREATE    PROCEDURE [dbo].[usp_StoryLines_Get]
--     @parmSeriesID		INT=null,
--     @parmIssueFrom		DECIMAL=null,
--     @parmIssueTo		DECIMAL=null
-- AS
-- BEGIN
-- 	SELECT 
-- 		StoryLines.StoryLineID,
-- 		StoryLines.StoryLineName
-- 	FROM Series 
-- 		INNER JOIN Issues 
-- 			INNER JOIN Pages 
-- 				INNER JOIN PageStoryArcs 
-- 					INNER JOIN StoryArcs 
-- 						INNER JOIN StoryLines ON 
-- 							StoryArcs.StoryLineID = StoryLines.StoryLineID ON 
-- 						PageStoryArcs.StoryArcID = StoryArcs.StoryArcID ON 
-- 					Pages.PageID = PageStoryArcs.PageID ON 
-- 				Issues.IssueID = Pages.IssueID ON 
-- 			Series.SeriesID = Issues.SeriesID
-- 	WHERE
-- 		Series.SeriesID = COALESCE(@parmSeriesID, Series.SeriesID)
-- 		AND Issues.IssueNumber >= COALESCE(@parmIssueFrom, Issues.IssueNumber)
-- 		AND Issues.IssueNumber <= COALESCE(@parmIssueTo, Issues.IssueNumber)
-- 	GROUP BY
-- 		StoryLines.StoryLineID,
-- 		StoryLines.StoryLineName
-- 	ORDER BY 
-- 		StoryLines.StoryLineName
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.usp_Page_UpdateStoryArc
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- CREATE PROCEDURE [dbo].[usp_Page_UpdateStoryArc]
--     @parmPageID			INT,
-- 	@parmStoryLineName	VARCHAR(255),
--     @parmStoryArcName	VARCHAR(255)
-- AS
-- BEGIN
-- 
-- 	DECLARE @StoryArcID INT
-- 
-- 	--CREATE TABLE #PageInfo (
-- 	--	PageID			INT,
-- 	--	PageNumber		DECIMAL,
-- 	--	PageFileNam		VARCHAR(255),
-- 	--	IssueNumber		DECIMAL,
-- 	--	FilePath		VARCHAR(255),
-- 	--	SeriesName		VARCHAR(255),
-- 	--	StoryLineName	VARCHAR(255),
-- 	--	StoryArcName	VARCHAR(255),
-- 	--	PageType		TINYINT,
-- 	--	LastQuickPickDate	DATETIME,
-- 	--	PageStoryArcID	INT,
-- 	--	PagesModificationDate DATETIME
-- 	--)
-- 
-- 	--INSERT INTO #PageInfo
-- 	--EXEC usp_PageInfo_Get
-- 	--	@parmSeriesName = @parmSeriesName,
-- 	--	@parmIssueNumber = @parmIssueNumber,
-- 	--	@parmPageNumber = @parmPageNumber
-- 
-- 
-- 	--IF @@ROWCOUNT > 0
-- 	--BEGIN
-- 
-- 		EXEC usp_StoryArcs_Upsert 
-- 			@parmStoryLineName = @parmStoryLineName,
-- 			@parmStoryArcName = @parmStoryArcName,
-- 			@parmStoryArcID	= @StoryArcID OUTPUT
-- 
-- 		UPDATE PageStoryArcs
-- 		SET PageStoryArcs.StoryArcID = @StoryArcID, ModificationDate = GetDate()
-- 		FROM PageStoryArcs
-- --			INNER JOIN #PageInfo ON PageStoryArcs.PageID = #PageInfo.PageID
-- 		WHERE PageID = @parmPageID
-- 	--END
-- END
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine Comics.fn_diagramobjects
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `Comics`$$
-- 
-- 	CREATE FUNCTION dbo.fn_diagramobjects() 
-- 	RETURNS int
-- 	WITH EXECUTE AS N'dbo'
-- 	AS
-- 	BEGIN
-- 		declare @id_upgraddiagrams		int
-- 		declare @id_sysdiagrams			int
-- 		declare @id_helpdiagrams		int
-- 		declare @id_helpdiagramdefinition	int
-- 		declare @id_creatediagram	int
-- 		declare @id_renamediagram	int
-- 		declare @id_alterdiagram 	int 
-- 		declare @id_dropdiagram		int
-- 		declare @InstalledObjects	int
-- 
-- 		select @InstalledObjects = 0
-- 
-- 		select 	@id_upgraddiagrams = object_id(N'dbo.sp_upgraddiagrams'),
-- 			@id_sysdiagrams = object_id(N'dbo.sysdiagrams'),
-- 			@id_helpdiagrams = object_id(N'dbo.sp_helpdiagrams'),
-- 			@id_helpdiagramdefinition = object_id(N'dbo.sp_helpdiagramdefinition'),
-- 			@id_creatediagram = object_id(N'dbo.sp_creatediagram'),
-- 			@id_renamediagram = object_id(N'dbo.sp_renamediagram'),
-- 			@id_alterdiagram = object_id(N'dbo.sp_alterdiagram'), 
-- 			@id_dropdiagram = object_id(N'dbo.sp_dropdiagram')
-- 
-- 		if @id_upgraddiagrams is not null
-- 			select @InstalledObjects = @InstalledObjects + 1
-- 		if @id_sysdiagrams is not null
-- 			select @InstalledObjects = @InstalledObjects + 2
-- 		if @id_helpdiagrams is not null
-- 			select @InstalledObjects = @InstalledObjects + 4
-- 		if @id_helpdiagramdefinition is not null
-- 			select @InstalledObjects = @InstalledObjects + 8
-- 		if @id_creatediagram is not null
-- 			select @InstalledObjects = @InstalledObjects + 16
-- 		if @id_renamediagram is not null
-- 			select @InstalledObjects = @InstalledObjects + 32
-- 		if @id_alterdiagram  is not null
-- 			select @InstalledObjects = @InstalledObjects + 64
-- 		if @id_dropdiagram is not null
-- 			select @InstalledObjects = @InstalledObjects + 128
-- 		
-- 		return @InstalledObjects 
-- 	END
-- 	$$
-- 
-- DELIMITER ;
-- SET FOREIGN_KEY_CHECKS = 1;
