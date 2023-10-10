CREATE OR ALTER PROCEDURE [Cfg].[All.JsonImport]
(
  @Data NVARCHAR(MAX)
)

AS      

BEGIN

  BEGIN TRANSACTION;
  BEGIN TRY     
    
    SET NOCOUNT ON;

    --Start of: JsonRead
    SELECT
     [Data].*
    INTO
      #Data
    FROM
    OPENJSON (@Data) WITH
    (
      Customers          NVARCHAR(MAX) '$.Customers' AS JSON,
      Processes          NVARCHAR(MAX) '$.Processes' AS JSON
    ) [Data];
    --End of: JsonRead

    --Start of: Customers
    MERGE INTO Cfg.Customers AS D USING   
    (
    SELECT
      [Data].Id AS Id,
      [Data].Code,
      [Data].Name,
      [Data].Description,
      [Data].Disabled
    FROM
      #Data R CROSS APPLY OPENJSON(R.Customers) WITH
      (
        Id                BIGINT        '$.Id',
        Code              NVARCHAR(32)  '$.InstallationId',
        Name              NVARCHAR(96)  '$.Name',
        Description       NVARCHAR(256) '$.Description',
        Disabled          BIT           '$.Disabled',
        Branches          NVARCHAR(MAX) '$.Branches' AS JSON,
        Projects          NVARCHAR(MAX) '$.Projects' AS JSON
      ) [Data]
    ) AS S ON (S.Id = D.Id)
  WHEN NOT MATCHED THEN INSERT
  (
    Id,
    Code,
    Name,
    Description,
    Disabled
  )
  VALUES
  (
    S.Id,
    S.Code,
    S.Name,
    S.Description,
    S.Disabled
  )
  WHEN MATCHED THEN UPDATE SET
    D.Code            =  S.Code,
    D.Name            =  S.Name,
    D.Description     =  S.Description,
    D.Disabled        =  S.Disabled;
    --End of: Customers

    --Start of: Processes
    MERGE INTO Cfg.Processes AS D USING   
    (
    SELECT
      [Data].Id AS Id,
      [Data].Code,
      [Data].Name,
      [Data].Description,
      [Data].Disabled,
      [Data].UI
    FROM
      #Data R CROSS APPLY OPENJSON(R.Processes) WITH
      (
        Id                BIGINT        '$.Id',
        Code              NVARCHAR(32)  '$.InstallationId',
        Name              NVARCHAR(96)  '$.Name',
        Description       NVARCHAR(256) '$.Description',
        Disabled          BIT           '$.Disabled',
        UI                BIT           '$.UI'
      ) [Data]
    ) AS S ON (S.Id = D.Id)
  WHEN NOT MATCHED THEN INSERT
  (
    Id,
    Code,
    Name,
    Description,
    Disabled,
    UI
  )
  VALUES
  (
    S.Id,
    S.Code,
    S.Name,
    S.Description,
    S.Disabled,
    S.UI
  )
  WHEN MATCHED THEN UPDATE SET
    D.Code            =  S.Code,
    D.Name            =  S.Name,
    D.Description     =  S.Description,
    D.Disabled        =  S.Disabled,
    D.UI              =  S.UI;
    --End of: Processes

    --Start of: Branches
    MERGE INTO Cfg.Branches AS D USING   
    (
    SELECT
      [Data].Id AS Id,
      [Data].CustomerId,
      [Data].Code,
      [Data].Name,
      [Data].Description,
      [Data].Disabled,
      [Data].AugmentedSecurity
    FROM
      #Data R CROSS APPLY OPENJSON(R.Customers.Branches) WITH
      (
        Id                BIGINT        '$.Id',
        CustomerId        BIGINT        '$.ServiceProviderId',
        Code              NVARCHAR(32)  '$.InstallationId',
        Name              NVARCHAR(96)  '$.Name',
        Description       NVARCHAR(256) '$.Description',
        Disabled          BIT           '$.Disabled',
        AugmentedSecurity BIT           '$.UI',
        DataAttributes    NVARCHAR(MAX) '$.DataAttributes' AS JSON
      ) [Data]
    ) AS S ON (S.Id = D.Id)
  WHEN NOT MATCHED THEN INSERT
  (
    Id,
    CustomerId,
    Code,
    Name,
    Description,
    Disabled,
    AugmentedSecurity
  )
  VALUES
  (
    S.Id,
    S.CustomerId,
    S.Code,
    S.Name,
    S.Description,
    S.Disabled,
    S.AugmentedSecurity
  )
  WHEN MATCHED THEN UPDATE SET
    D.CustomerId        =  S.CustomerId,
    D.Code              =  S.Code,
    D.Name              =  S.Name,
    D.Description       =  S.Description,
    D.Disabled          =  S.Disabled,
    D.AugmentedSecurity =  S.AugmentedSecurity;
    --End of: Branches
    
    --Start of: Projects
    MERGE INTO Cfg.Projects AS D USING   
    (
    SELECT
      [Data].Id AS Id,
      [Data].CustomerId,
      [Data].Code,
      [Data].Name,
      [Data].Description,
      [Data].Disabled
    FROM
      #Data R CROSS APPLY OPENJSON(R.Customers.Projects) WITH
      (
        Id                BIGINT        '$.Id',
        CustomerId        BIGINT        '$.CustomerId',
        Code              NVARCHAR(32)  '$.Code',
        Name              NVARCHAR(96)  '$.Name',
        Description       NVARCHAR(256) '$.Description',
        Disabled          BIT           '$.Disabled',
        Categories        NVARCHAR(MAX) '$.Categories' AS JSON
      ) [Data]
    ) AS S ON (S.Id = D.Id)
  WHEN NOT MATCHED THEN INSERT
  (
    Id,
    CustomerId,
    Code,
    Name,
    Description,
    Disabled
  )
  VALUES
  (
    S.Id,
    S.CustomerId,
    S.Code,
    S.Name,
    S.Description,
    S.Disabled
  )
  WHEN MATCHED THEN UPDATE SET
    D.CustomerId      =  S.CustomerId,
    D.Code            =  S.Code,
    D.Name            =  S.Name,
    D.Description     =  S.Description,
    D.Disabled        =  S.Disabled;
    --End of: Projects

    --Start of: Categories
    MERGE INTO Cfg.Categories AS D USING   
    (
    SELECT
      [Data].Id AS Id,
      [Data].ProjectId,
      [Data].Code,
      [Data].Name,
      [Data].Description,
      [Data].Disabled
    FROM
      #Data R CROSS APPLY OPENJSON(R.Customers.Projects) WITH
      (
        Id                BIGINT        '$.Id',
        ProjectId         BIGINT        '$.ProjectId',
        Code              NVARCHAR(32)  '$.Code',
        Name              NVARCHAR(96)  '$.Name',
        Description       NVARCHAR(256) '$.Description',
        Disabled          BIT           '$.Disabled',
        DataAttributes    NVARCHAR(MAX) '$.DataAttributes' AS JSON,
        ContentClasses    NVARCHAR(MAX) '$.ContentClasses' AS JSON,
        ProductionLines   NVARCHAR(MAX) '$.ProductionLines' AS JSON
      ) [Data]
    ) AS S ON (S.Id = D.Id)
  WHEN NOT MATCHED THEN INSERT
  (
    Id,
    ProjectId,
    Code,
    Name,
    Description,
    Disabled
  )
  VALUES
  (
    S.Id,
    S.ProjectId,
    S.Code,
    S.Name,
    S.Description,
    S.Disabled
  )
  WHEN MATCHED THEN UPDATE SET
    D.ProjectId       =  S.ProjectId,
    D.Code            =  S.Code,
    D.Name            =  S.Name,
    D.Description     =  S.Description,
    D.Disabled        =  S.Disabled;
    --End of: Categories

    --Start of: ProductionLines
    MERGE INTO Cfg.ProductionLines AS D USING   
    (
    SELECT
      R.Id AS Id,
      [Data].CategoryId,
      [Data].Code,
      [Data].Name,
      [Data].Description,
      [Data].Disabled
    FROM
      #Data R CROSS APPLY OPENJSON(R.Customers.Projects.Categories.ProductionLines) WITH
      (
        Id                BIGINT        '$.Id',
        CategoryId        BIGINT        '$.CategoryId',
        Code              NVARCHAR(32)  '$.Code',
        Name              NVARCHAR(96)  '$.Name',
        Description       NVARCHAR(256) '$.Description',
        Disabled          BIT           '$.Disabled',
        ProductionSteps   NVARCHAR(MAX) '$.ProductionSteps' AS JSON
      ) [Data]
    ) AS S ON (S.Id = D.Id)
  WHEN NOT MATCHED THEN INSERT
  (
    Id,
    CategoryId,
    Code,
    Name,
    Description,
    Disabled
  )
  VALUES
  (
    S.Id,
    S.CategoryId,
    S.Code,
    S.Name,
    S.Description,
    S.Disabled
  )
  WHEN MATCHED THEN UPDATE SET
    D.CategoryId      =  S.CategoryId,
    D.Code            =  S.Code,
    D.Name            =  S.Name,
    D.Description     =  S.Description,
    D.Disabled        =  S.Disabled;
    --End of: ProductionLines

    --Start of: ProductionSteps
    MERGE INTO Cfg.ProductionSteps AS D USING   
    (
    SELECT
      R.Id AS Id,
      [Data].ProductionLineId,
      [Data].ProcessId,
      [Data].Code,
      [Data].Name,
      [Data].Description,
      [Data].Disabled
    FROM
      #Data R CROSS APPLY OPENJSON(R.Customers.Projects.Categories.ProductionLines.ProductionSteps) WITH
      (
        Id                BIGINT        '$.Id',
        ProductionLineId  BIGINT        '$.ProductionLineId',
        ProcessId         BIGINT        '$.ProcessId',
        Code              NVARCHAR(32)  '$.Code',
        Name              NVARCHAR(96)  '$.Name',
        Description       NVARCHAR(256) '$.Description',
        Disabled          BIT           '$.Disabled'
      ) [Data]
    ) AS S ON (S.Id = D.Id)
  WHEN NOT MATCHED THEN INSERT
  (
    Id,
    ProcessId,
    ProductionLineId,
    Code,
    Name,
    Description,
    Disabled
  )
  VALUES
  (
    S.Id,
    S.ProcessId,
    S.ProductionLineId,
    S.Code,
    S.Name,
    S.Description,
    S.Disabled
  )
  WHEN MATCHED THEN UPDATE SET
    D.ProcessId         =  S.ProcessId,
    D.ProductionLineId  =  S.ProductionLineId,
    D.Code              =  S.Code,
    D.Name              =  S.Name,
    D.Description       =  S.Description,
    D.Disabled          =  S.Disabled;
    --End of: ProductionSteps

    --Start of: ContentClasses
    MERGE INTO Cfg.ContentClasses AS D USING   
    (
    SELECT
      R.Id AS Id,
      [Data].ProductionLineId,
      [Data].Code,
      [Data].Name,
      [Data].Description,
      [Data].Disabled
    FROM
      #Data R CROSS APPLY OPENJSON(R.Customers.Projects.Categories.ProductionLines.ContentClasses) WITH
      (
        Id                BIGINT        '$.Id',
        ProductionLineId  BIGINT        '$.ProductionLineId',
        Code              NVARCHAR(32)  '$.Code',
        Name              NVARCHAR(96)  '$.Name',
        Description       NVARCHAR(256) '$.Description',
        Disabled          BIT           '$.Disabled'
      ) [Data]
    ) AS S ON (S.Id = D.Id)
  WHEN NOT MATCHED THEN INSERT
  (
    Id,
    ProductionLineId,
    Code,
    Name,
    Description,
    Disabled
  )
  VALUES
  (
    S.Id,
    S.ProductionLineId,
    S.Code,
    S.Name,
    S.Description,
    S.Disabled
  )
  WHEN MATCHED THEN UPDATE SET
    D.ProductionLineId    =  S.ProductionLineId,
    D.Code                =  S.Code,
    D.Name                =  S.Name,
    D.Description         =  S.Description,
    D.Disabled            =  S.Disabled;
    --End of: ContentClasses
    
    --Start of: DataAttributes

    --Select From Branches
    INSERT INTO #DataAttributes (ParentId, Name, Value )
    SELECT
        JSON_VALUE(@Data,'$.Id') AS ParentId,
        JSON_VALUE(DataAttributes,'$.name') AS Name,
        JSON_VALUE(DataAttributes,'$.value') AS Value
        
    FROM 
      OPENJSON(@Data, '$.Customers.Branches') WITH 
      (
        DataAttributes NVARCHAR(MAX) '$.DataAttributes' AS JSON
      );

    --Select From Categories
    INSERT INTO #DataAttributes (ParentId, Name, Value )
    SELECT
        JSON_VALUE(@Data,'$.Id') AS ParentId,
        JSON_VALUE(DataAttributes,'$.name') AS Name,
        JSON_VALUE(DataAttributes,'$.value') AS Value
    FROM 
      OPENJSON(@Data, '$.Customers.Projects.Categories') WITH 
      (
        DataAttributes NVARCHAR(MAX) '$.DataAttributes' AS JSON
      );
       
    MERGE INTO Cfg.DataAttributes AS D USING   
    (
    SELECT
      R.ParentId,
      R.Name,
      R.Value
      FROM
      #Data R
    ) AS S ON (S.ParentId = D.ParentId)
    WHEN NOT MATCHED THEN INSERT
    (
      ParentId,
      Name,
      Value
    )
    VALUES
    (
      S.ParentId,
      S.Name,
      S.Value
    )
    WHEN MATCHED THEN UPDATE SET
      D.Name            =  S.Name,
      D.Value           =  S.Value;
    --End of: DataAttributes
    DROP TABLE #Data;


         
    COMMIT TRANSACTION;
                    
  END TRY                      
  BEGIN CATCH

    ROLLBACK TRANSACTION;

  END CATCH

END