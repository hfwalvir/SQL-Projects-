--Converting SaleDate to proper format

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM ProjectPortfolio..NashvilleHousing

UPDATE ProjectPortfolio..NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE ProjectPortfolio..NashvilleHousing
ADD SaleDateConverted date 

UPDATE ProjectPortfolio..NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


--POPULATING PROPERTY ADDRESS DATA
Select *
FROM ProjectPortfolio..NashvilleHousing
-- WHERE PropertyAddress is null
ORDER BY  ParcelID

SELECT a.ParcelID,a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) 
FROM ProjectPortfolio..NashvilleHousing as a
JOIN ProjectPortfolio..NashvilleHousing as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM ProjectPortfolio..NashvilleHousing as a
JOIN ProjectPortfolio..NashvilleHousing as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]


--Breaking out Address into Individual Columns (Address, City, State)

Select *
FROM ProjectPortfolio..NashvilleHousing


SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',' ,PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress,CHARINDEX(',' ,PropertyAddress)+1, LEN(PropertyAddress)) as Address
FROM ProjectPortfolio..NashvilleHousing

 
ALTER TABLE ProjectPortfolio..NashvilleHousing
ADD PropertySplitAddress nvarchar(255)

UPDATE ProjectPortfolio..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',' ,PropertyAddress)-1)

ALTER TABLE ProjectPortfolio..NashvilleHousing
ADD PropertySplitCity nvarchar(255)

UPDATE ProjectPortfolio..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',' ,PropertyAddress)+1, LEN(PropertyAddress))

SELECT * FROM ProjectPortfolio..NashvilleHousing

-- Breaking down OwnerAddress 

Select *
FROM ProjectPortfolio..NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',' , ','), 1)
,PARSENAME(REPLACE(OwnerAddress, ',' , ','), 2)
,PARSENAME(REPLACE(OwnerAddress, ',' , ','), 3)
FROM ProjectPortfolio..NashvilleHousing

ALTER TABLE ProjectPortfolio..NashvilleHousing
ADD OwnerSplitAddress nvarchar(255)

UPDATE ProjectPortfolio..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , ','), 1)

ALTER TABLE ProjectPortfolio..NashvilleHousing
ADD OwnerSplitCity nvarchar(255)

UPDATE ProjectPortfolio..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , ','), 2)

ALTER TABLE ProjectPortfolio..NashvilleHousing
ADD OwnerSplitState nvarchar(255)

UPDATE ProjectPortfolio..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , ','), 3)

SELECT *
FROM ProjectPortfolio..NashvilleHousing

--Change 'Y' AND 'N' TO Yes and no

Select Distinct(SoldAsVacant) , Count(SoldAsVacant)
FROM ProjectPortfolio..NashvilleHousing
GROUP BY SoldAsVacant 
ORDER BY 2

Select SoldAsVacant,
CASE
 WHEN SoldAsVacant ='Y' then 'YES'
 WHEN SoldAsVacant ='N' then 'NO'
 ELSE SoldAsVacant
END
FROM ProjectPortfolio..NashvilleHousing

UPDATE ProjectPortfolio..NashvilleHousing
Set SoldAsVacant = 
CASE
 WHEN SoldAsVacant ='Y' then 'YES'
 WHEN SoldAsVacant ='N' then 'NO'
 ELSE SoldAsVacant
END
Select SoldAsVacant,
CASE
 WHEN SoldAsVacant ='Y' then 'YES'
 WHEN SoldAsVacant ='N' then 'NO'
 ELSE SoldAsVacant
END
FROM ProjectPortfolio..NashvilleHousing

SELECT*
FROM ProjectPortfolio..NashvilleHousing


-- removing duplicates
WITH RowNumCTE AS (
SELECT *,
    ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference ORDER BY UniqueID) as RowNumber
FROM ProjectPortfolio..NashvilleHousing 
)
--ORDER BY ParcelID)

SELECT *
FROM  RowNumCTE
WHERE RowNumber > 1
--Order By PropertyAddress

-- now deleting the columns that are unused

SELECT *
FROM ProjectPortfolio..NashvilleHousing 

ALTER TABLE ProjectPortfolio..NashvilleHousing 
DROP COLUMN SaleDate, TaxDistrict, OwnerAddress, PropertyAddress
