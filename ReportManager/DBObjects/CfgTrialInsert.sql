CREATE OR ALTER PROCEDURE Cfg.[Reports.Initialize]
(
  @NumberOfReports INT=0,
  @NumberOfMembers INT=0,
  @NumberOfVisits INT=0,
  @NumberOfCities INT=0,
  @NumberOfInstallations INT=0
)

AS      

BEGIN

  SET NOCOUNT ON;

  BEGIN TRANSACTION;
  BEGIN TRY          
    

    DECLARE
      @i INT = 1,
      @k INT = 1,
      @j INT = 1,
      @c INT = 1,
      @in INT =1,
      @RId INT = INT.NewId(),
      @MId INT = INT.NewId(),
      @VId INT = INT.NewId(),
      @CId INT = INT.NewId(),
      @InId INT = INT.NewId(),
      @TotalRowsInserted INT = 0,
      @TotalRowsInsertedInR INT = 0,
      @TotalRowsInsertedInM INT = 0,
      @TotalRowsInsertedInV INT = 0,
      @TotalRowsInsertedInC INT = 0,
      @TotalRowsInsertedInInsta INT = 0;

      --Start of: Cities
    WHILE @c <= @NumberOfCities 
    BEGIN
      INSERT INTO [Cfg].Cities
      (
        Id,
        Name
      )
      VALUES
      (
        @CId,
        'C-'+CONVERT(VARCHAR(4),@i)
      );

      -- Start Of: Cfg.Installations
      WHILE @in <= @NumberOfInstallations 
        BEGIN
          INSERT INTO Cfg.Installations
          (
            Id,
            CityId,
            [Name]
          )
          VALUES
          ( 
            @InId, 
            @CId, 
            'C-'+CONVERT(VARCHAR(4),@i)+'-Inst-'+CONVERT(VARCHAR(4),@j)
          );
          SET @CId = @CId +1;
          -- Start Of: Cfg.Reports
          WHILE @i <= @NumberOfReports 
            BEGIN
              INSERT INTO [Cfg].Reports
              (
                Id,
                Name,
                Surname,
                Address,
                CityId,
                InId,
                Need,
                Active,
                Details
              )
              VALUES
              (
                @RId,
                'R-Name-'+CONVERT(VARCHAR(4),@i),
                'R-Surname-'+CONVERT(VARCHAR(4),@i),
                'R-Address-'+CONVERT(VARCHAR(4),@i),
                @CId,
                @InId,
                1,
                1,
                'R-Details-'+CONVERT(VARCHAR(4),@i)
              );

              -- Start Of: Cfg.Members
              WHILE @j <= @NumberOfMembers 
                BEGIN
                  INSERT INTO Cfg.Members
                  (
                    Id,
                    Connector,
                    [Member],
                    [Name],
                    YearOfBirth,
                    Age,
                    Details
                  )
                  VALUES
                  ( 
                    @MId, 
                    @RId, 
                    'R-'+CONVERT(VARCHAR(4),@i)+'-Member-'+CONVERT(VARCHAR(4),@j),
                    'R-'+CONVERT(VARCHAR(4),@i)+'-Name-'+CONVERT(VARCHAR(4),@j),
                    1990+@j,
                    @j,
                    'R-'+CONVERT(VARCHAR(4),@i)+'-Name-'+CONVERT(VARCHAR(4),@j) 
                  );
                  SET @MId = @MId +1;
                  SET @j = @j + 1;
                  SET @TotalRowsInserted = @TotalRowsInserted +1;
                  SET @TotalRowsInsertedInM = @TotalRowsInsertedInM +1;
                END;
                -- End Of: Cfg.Members
                -- Start Of: Cfg.Visits
                SET @j = 1
                WHILE @k <= @NumberOfVisits
                  BEGIN
                    INSERT INTO [Cfg].Visits 
                    (
                      Id,
                      Connector,
                      InIdOwner,
                      InIdVisitor,
                      VisitorName,
                      Details,
                      DateOfVisit
                    )
                    VALUES
                    ( 
                      @VId, 
                      @RId, 
                      @InId,
                      @InId,
                      'R-'+CONVERT(VARCHAR(4),@i)+'-VisitorName-'+CONVERT(VARCHAR(4),@k),
                      'R-'+CONVERT(VARCHAR(4),@i)+'-VisitDetails-'+CONVERT(VARCHAR(4),@k),
                      '2022-12-18'
                    );
                    SET @VId = @VId + 1
                    SET @k = @k + 1
                    SET @TotalRowsInserted = @TotalRowsInserted +1
                    SET @TotalRowsInsertedInV = @TotalRowsInsertedInV +1
                  END
                  -- End Of: Cfg.Visits
                  SET @k = 1
                  SET @i = @i + 1
                  SET @RId = @RId +1
                  SET @TotalRowsInserted = @TotalRowsInserted +1
                  SET @TotalRowsInsertedInR = @TotalRowsInsertedInR +1
              END
              -- End Of: Cfg.Reports

          SET @InId = @InId +1;
          SET @in = @in + 1;
          SET @TotalRowsInserted = @TotalRowsInserted +1;
          SET @TotalRowsInsertedInInsta = @TotalRowsInsertedInInsta +1;
        END;
          -- End Of: Cfg.Installations
        SET @in = 1
        SET @c = @c + 1
        SET @CId = @CId +1
        SET @TotalRowsInserted = @TotalRowsInserted +1
        SET @TotalRowsInsertedInC = @TotalRowsInsertedInC +1
    END
    --End Of: Cities
    
    
    SELECT
      @TotalRowsInserted AS TotalRowsInserted,
      @TotalRowsInsertedInR AS Reports,
      @TotalRowsInsertedInM AS Members,
      @TotalRowsInsertedInV AS Visits,
      @TotalRowsInsertedInC AS Cities,
      @TotalRowsInsertedInInsta AS Installations;

    COMMIT TRANSACTION;                    
  END TRY        
  BEGIN CATCH
    DECLARE
      @ErrorMessage NVARCHAR(4000),
      @ErrorSeverity INT,
      @ErrorState INT;

    SELECT
      @ErrorMessage = ERROR_MESSAGE(),
      @ErrorSeverity = ERROR_SEVERITY(),
      @ErrorState = ERROR_STATE();

    ROLLBACK TRANSACTION;
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
  END CATCH

END