SELECT *
FROM cleaning.dbo.NashvilleHousing ;

--------------Standardizing Date Format

SELECT SaleDate
FROM cleaning.dbo.NashvilleHousing ;

SELECT CONVERT(Date, SaleDate)
FROM cleaning.dbo.NashvilleHousing ;

ALTER TABLE cleaning.dbo.[NashvilleHousing ]
ADD SaleDateConverted Date;

UPDATE cleaning.dbo.NashvilleHousing 
SET SaleDateConverted = CONVERT(Date, SaleDate)

--------------Property Address
SELECT *
FROM cleaning.dbo.NashvilleHousing
WHERE PropertyAddress is NULL;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM cleaning.dbo.NashvilleHousing a
JOIN cleaning.dbo.NashvilleHousing b
 on a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
 WHERE a.PropertyAddress is NULL
;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM cleaning.dbo.NashvilleHousing a
JOIN cleaning.dbo.NashvilleHousing b
 on a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
 WHERE a.PropertyAddress is NULL;

 ----breaking out (address, city, state)

 SELECT PropertyAddress, SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
 TRIM(SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress))) as Town
 FROM cleaning.dbo.NashvilleHousing
 ;

ALTER TABLE cleaning.dbo.NashvilleHousing
ADD Address Nvarchar(255);

UPDATE cleaning.dbo.NashvilleHousing
SET Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);


ALTER TABLE cleaning.dbo.NashvilleHousing
ADD PropertyCity Nvarchar(255);

UPDATE cleaning.dbo.NashvilleHousing
SET PropertyCity = TRIM(SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)));

SELECT OwnerAddress
FROM cleaning.dbo.NashvilleHousing;

SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS OwnerCity,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS OwnerState
FROM cleaning.dbo.NashvilleHousing;

ALTER TABLE cleaning.dbo.NashvilleHousing
ADD SplitOwnerAddress Nvarchar(255);

UPDATE cleaning.dbo.NashvilleHousing
SET SplitOwnerAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

ALTER TABLE cleaning.dbo.NashvilleHousing
ADD SplitOwnerCity Nvarchar(255);

UPDATE cleaning.dbo.NashvilleHousing
SET SplitOwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

ALTER TABLE cleaning.dbo.NashvilleHousing
ADD SplitOwnerState Nvarchar(255);

UPDATE cleaning.dbo.NashvilleHousing
SET SplitOwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

--------change y and n to yes and no in "Sold as Vacant"

Select Distinct( SoldAsVacant)
FROM cleaning.dbo.NashvilleHousing;


SELECT SoldAsVacant,
	CASE	
		When SoldAsVacant = 0 then 'No'
		ELSE 'Yes'
		END as UpdSoldAsVacant
FROM cleaning.dbo.NashvilleHousing

ALTER TABLE cleaning.dbo.NashvilleHousing
ADD UpdSoldAsVacant Nvarchar(255);

UPDATE cleaning.dbo.NashvilleHousing
SET UpdSoldAsVacant = CASE	
		When SoldAsVacant = 0 then 'No'
		ELSE 'Yes'
		END

SELECT *
FROM cleaning.dbo.NashvilleHousing;

---remove duplicates
WITH RowNumCTE as(
SELECT *, ROW_NUMBER() over(partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) as row_num
FROM cleaning.dbo.NashvilleHousing
)

DELETE 
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress
;


--Delete unused columns 
-----SaleDate
-----PropertyAddress

SELECT *
FROM cleaning.dbo.NashvilleHousing ;