SELECT *
FROM train;

SELECT *
FROM test;


EXEC sp_help train;

EXEC sp_help test;



UPDATE train
SET GarageYrBlt = NULL
WHERE GarageYrBlt = 'NA';

UPDATE train
SET LotFrontage = NULL
WHERE LotFrontage = 'NA';

CREATE VIEW training_data AS
SELECT Id, MSSubClass, MSZoning, LotArea, Neighborhood, OverallQual, GrLivArea, SalePrice
FROM train;

CREATE VIEW testing_data AS
SELECT Id, MSSubClass, MSZoning, LotArea, Neighborhood, OverallQual, GrLivArea
FROM test;


SELECT *
FROM predicted_table;

CREATE VIEW predictions AS
SELECT Id, MSSubClass, MSZoning, LotArea, Neighborhood, OverallQual, GrLivArea, predicted_sale_price
FROM predicted_table;


