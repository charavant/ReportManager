CREATE OR ALTER PROCEDURE Cfg.[PerCity.JsonSelect]
(
  @CustomerId BIGINT
)
AS      

BEGIN
  BEGIN TRY
  BEGIN TRANSACTION;

    SET NOCOUNT ON;

    --Start of: Cities
    SELECT
      Id,
      [Name],
      --Start of: Installations
      (
      SELECT
        Id,
        CityId,
        [Name],
        --Start of: Reports
        ( 
        SELECT 
          Id,
          Name,
          Surname,
          Address,
          CityId,
          InId,
          Need,
          Active,
          Details,
          --Start of: Members
          ( 
          SELECT 
            Id,
            Connector,
            [Member],
            [Name],
            YearOfBirth,
            Age,
            Details
          FROM 
            Cfg.Members AS M
          WHERE
            M.Connector = R.Id
          FOR JSON AUTO
          ),
          --End of: Members
          --Start of: Visits
          ( 
          SELECT 
            Id,
            Connector,
            InIdOwner,
            InIdVisitor,
            VisitorName,
            Details,
            DateOfVisit
          FROM 
            Cfg.Visits AS V
          WHERE 
            V.Connector = R.Id
          FOR JSON AUTO
          )
          --End of: Visits
        FROM 
          Cfg.Reports AS R
        WHERE 
          R.InId = I.Id
        FOR JSON AUTO  
        )
        --End of: Reports
      FROM 
        Cfg.Installations AS I
      WHERE  
        I.CityId = C.Id
      FOR JSON AUTO
      )
      --End of: DataAttributes
    FROM
     Cfg.Cities AS C    
    FOR JSON PATH, Without_Array_Wrapper
    --End of: Branches

  COMMIT TRANSACTION;
  END TRY 
  BEGIN CATCH

    ROLLBACK TRANSACTION;

  END CATCH;

END