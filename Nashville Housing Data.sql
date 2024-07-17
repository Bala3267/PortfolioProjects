/* 
	Data Cleaning in SQL

	*/

-- Creating a Database for National Housing Data
CREATE DATABASE Housing

-- Import the Nashville Housing data into Housing Database

-- Look at the Nashville House Data
USE Housing
SELECT * FROM Nashville_Housing



-- Data Preparation and Cleaning
------------------------------------------------------

-- Checking If UniqueID is contain any duplicate values
SELECT UniqueID, Count(UniqueID) as CNT FROM Nashville_Housing
GROUP BY UniqueId
HAVING Count(UniqueID) >1;

-- Checking for missing values in unique_id column 
SELECT UniqueId FROM Nashville_Housing
WHERE UniqueId is null;

-- Checking duplicate values in Land_Use
SELECT LandUse, Count(LandUse) as CNT FROM Nashville_Housing
GROUP BY LandUse
ORDER BY 1


--- Updating LandUse column Value in Nashville Housing Table
-----------------------------------------------------------------------
-- Adjusting categories of 'VACANT RESIDENTIAL LAND'  in LandUse Column.
UPDATE Nashville_Housing
SET LandUse = 'VACANT RESIDENTIAL LAND'
WHERE LandUse = 'VACANT RES LAND'
Or LandUse = 'VACANT RESIENTIAL LAND'
Or LandUse = 'VACANT ZONED MULTI FAMILY'

-- Adjusting categories of forest related Land in LandUse Column.
UPDATE Nashville_Housing
SET LandUse = 'GREEN BELT'
WHERE LandUse = 'FOREST'
Or LandUse = 'GREENBELT/RES  GRRENBELT/RES'
Or LandUse Like 'GREENBELT%'

-- Adjusting categories of low-rise appartment land use in LandUse Column.
UPDATE Nashville_Housing
SET LandUse = 'LOW RISE APPARTMENT'
WHERE LandUse = 'APARTMENT: LOW RISE (BUILT SINCE 1960)'
Or LandUse = 'SPLIT CLASS'


-- Adjusting categories of night entertainment landUse Column.
UPDATE Nashville_Housing
SET LandUse = 'NIGHT ENTERTAINMENT'
WHERE LandUse = 'NIGHTCLUB/LOUNGE'
Or LandUse = 'CLUB/UNION HALL/LODGE'


-- Adjusting categories for condominium-related land use.
UPDATE Nashville_Housing
SET LandUse = 'CONDOMINIUM'
WHERE LandUse = 'CONDOMINIUM OFC  OR OTHER COM CONDO'
Or LandUse = 'CONDO'
Or LandUse = 'RESIDENTIAL CONDO'
Or LandUse = 'RESIDENTIAL COMBO/MISC'


--Adjusting typos of office land in LandUse Column.
UPDATE Nashville_Housing
SET LandUse = 'OFFICE'
WHERE LandUse = 'OFFICE BLDG (ONE OR TWO STORIES)'

--Adjusting categories for commercial-related land use
UPDATE Nashville_Housing
SET LandUse = 'COMMERCIAL LAND'
WHERE LandUse = 'ONE STORY GENERAL RETAIL STORE'
Or LandUse = 'SMALL SERVICE SHOP'
Or LandUse = 'CONVENIENCE MARKET WITHOUT GAS'
Or LandUse = 'STRIP SHOPPING CENTER'
Or LandUse = 'DAY CARE CENTER'
Or LandUse = 'LIGHT MANUFACTURING'
Or LandUse = 'PARKING LOT'
Or LandUse = 'RESTAURANT'


 --Adjusting categories for transportation-related land use
UPDATE Nashville_Housing
SET LandUse = 'TRANSPORTATION'
WHERE LandUse ='METRO OTHER THAN OFC, SCHOOL,HOSP, OR PARK'

-- Adjusting categories for distribution-related land use
UPDATE Nashville_Housing
SET LandUse = 'DISTRIBUTION'
WHERE LandUse = 'TERMINAL/DISTRIBUTION WAREHOUSE'

-- Adjusting typos of restaurant
UPDATE Nashville_Housing
SET LandUse = 'RESTAURANT'
WHERE LandUse = 'RESTURANT/CAFETERIA'

SELECT LandUse, Count(LandUse) as CNT FROM Nashville_Housing
GROUP BY LandUse
ORDER BY 2
----------------------------------------------------------------------------------


-- Checking If Property Address contain any null values
SELECT * FROM Nashville_Housing
WHERE PropertyAddress is null

 -- Checking if PropertyAddress contain any null values.
 
 SELECT * FROM Nashville_Housing
 WHERE PropertyAddress is null
 ORDER BY ParcelID

  -- Populate Property Address in Property Address Column Where Property Address IS NULL.
 SELECT nh1.ParcelID,nh1.PropertyAddress,nh2.ParcelID,nh2.PropertyAddress, 
		ISNULL(nh1.PropertyAddress,nh2.PropertyAddress) 
 FROM Nashville_Housing nh1
 JOIN Nashville_Housing nh2
	ON nh1.ParcelID = nh2.ParcelID
	And nh1.UniqueID <> nh2.UniqueID
WHERE nh1.PropertyAddress is null

UPDATE nh1
SET PropertyAddress = ISNULL(nh1.PropertyAddress,nh2.PropertyAddress) 
FROM Nashville_Housing nh1
JOIN Nashville_Housing nh2
	ON nh1.ParcelID = nh2.ParcelID
	And nh1.UniqueID <> nh2.UniqueID
WHERE nh1.PropertyAddress is null



--Breaking out Address into Individual Column (Address, City, State)
----------------------------------------------------------------------------

ALTER TABLE Nashville_Housing
ADD PropertySplitCity nvarchar(50)

UPDATE Nashville_Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE Nashville_Housing
ADD PropertySplitState nvarchar(50)

UPDATE Nashville_Housing
SET PropertySplitState = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


--- Breaking OwnerAddress into (Address, City, State)
-----------------------------------------------------------------------
SELECT OwnerAddress
FROM Nashville_Housing

ALTER TABLE Nashville_Housing
ADD OwnerSplitAddress nvarchar(50),
	OwnerSplitCity nvarchar(50),
	OwnerSplitState nvarchar(50)


UPDATE Nashville_Housing
SET OwnerSplitAddress = PARSENAME(replace(ownerAddress,',','.'),3),
	OwnerSplitCity =  PARSENAME(replace(ownerAddress,',','.'),2),
	OwnerSplitState = PARSENAME(replace(ownerAddress,',','.'),1)



---------------------------------------------------------------------------
-- Removing Null Value in LandValue, BuildingValue and OwnerAddress
----------------------------------------------------------------------------
DELETE FROM Nashville_Housing
WHERE BuildingValue Is Null 
Or BuildingValue Is Null 
Or OwnerAddress Is Null


-- Checking If any Null Values in LandValue, BuildingValue and OwnerAddress
SELECT * FROM Nashville_Housing
WHERE LandValue is null or BuildingValue is null or OwnerAddress is null
----------------------------------------------------------------------------





--- Data Analysis Process
-----------------------------------------------------------------------------
-- Q1) ‘How is the business condition in terms of profit growth in the last few years?

SELECT DATEPART(YEAR,SaleDate) as 'YEAR',
	   Sum(SalePrice - LandValue - BuildingValue) as Profit
FROM Nashville_Housing
GROUP BY DATEPART(YEAR,SaleDate)
ORDER BY DATEPART(YEAR,SaleDate) Desc;


-- Q2) Calculating the count per land_use type
SELECT * FROM Nashville_Housing

SELECT DATEPART(YEAR,SaleDate) as 'YEAR', LandUse, Count(Landuse) as CNT
FROM Nashville_Housing
WHERE  DATEPART(YEAR,SaleDate) <> 2019
GROUP BY DATEPART(YEAR,SaleDate),LandUse
ORDER BY  DATEPART(YEAR,SaleDate) Desc, CNT Desc


-- Q3) Calculating the total revenue per land_use type
SELECT DATEPART(Year,SaleDate) As Year, LandUse ,Sum(SalePrice) As Total_Revenue
FROM Nashville_Housing
WHERE DATEPART(Year,SaleDate) != 2019
GROUP BY DATEPART(Year,SaleDate), LandUse
ORDER BY DATEPART(Year,SaleDate) Desc, Total_Revenue Desc


-- Q4) Counting Number of Cities and Land use
SELECT DATEPART(Year, SaleDate) as Year,PropertySplitState, LandUse,
	count(LandUse) as 'Land Use Type'
FROM Nashville_Housing
WHERE DATEPART(Year, SaleDate) != 2019
GROUP BY DATEPART(Year, SaleDate),PropertySplitState, LandUse
ORDER BY DATEPART(Year, SaleDate) Desc, [Land Use Type] Desc



-- Completed-------
------------------------------*******------------------------------------------------------------------


