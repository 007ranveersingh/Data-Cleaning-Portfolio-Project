

  -- CLEANING DATA IN SQL QUERIES


  SELECT * 
  FROM PortfolioProject..NashvilleHousing
  ------------------------------------------------------------------------------------------------------------
  
  -- Standardize Date format

  ALTER TABLE NashvilleHousing --Add a column named SalesDateConverted 
  ADD SaleDateConverted Date

  UPDATE NashvilleHousing -- Set the added column as the Converted one
  SET SaleDateConverted = CONVERT(Date, SaleDate)

  SELECT SaleDateConverted
  FROM PortfolioProject..NashvilleHousing

  -----------------------------------------------------------------------------------------------------------
  
  -- Populate Property Address data
  
  SELECT *
  FROM PortfolioProject..NashvilleHousing
  WHERE PropertyAddress IS NULL
  --ORDER BY ParcelID

  SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
  FROM PortfolioProject..NashvilleHousing a
  JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL 

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
  JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL 

-- Breaking Out Address into Individual Columns (Address, City, State)

  SELECT PropertyAddress
  FROM PortfolioProject..NashvilleHousing
  
  SELECT 
  SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) AS Address
  , SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) AS Address
  FROM PortfolioProject..NashvilleHousing

  
  ALTER TABLE NashvilleHousing 
  ADD PropertySplitAddress nvarchar(255)

  UPDATE NashvilleHousing -- Set the added column as the Converted one
  SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1)

  
  ALTER TABLE NashvilleHousing 
  ADD PropertySplitCity nvarchar(255)

  UPDATE NashvilleHousing 
  SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))


SELECT * FROM PortfolioProject..NashvilleHousing


-- Breaking Out OwnerAddress into Individual Columns (Address, City, State)

  SELECT OwnerAddress
  FROM PortfolioProject..NashvilleHousing

  SELECT 
  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
  FROM PortfolioProject..NashvilleHousing

    ALTER TABLE NashvilleHousing 
  ADD OwnerSplitAddress_ nvarchar(255)

  UPDATE NashvilleHousing 
  SET OwnerSplitAddress_ =   PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

    ALTER TABLE NashvilleHousing 
  ADD OwnerSplitCity nvarchar(255)

  UPDATE NashvilleHousing 
  SET OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

    ALTER TABLE NashvilleHousing 
  ADD OwnerSplitState nvarchar(255)

  UPDATE NashvilleHousing 
  SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

  SELECT *
  FROM PortfolioProject..NashvilleHousing

  -----------------------------------------------------------------------------------------------------------

  -- Change Y and N to Yes and No in 'Sold as Vacant' Field

   SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
  FROM PortfolioProject..NashvilleHousing
  GROUP BY SoldAsVacant
  ORDER BY 2


  SELECT SoldAsVacant,
  CASE WHEN SoldAsVacant = 'Y' THEN 'YEs'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant 
		END 
  FROM PortfolioProject..NashvilleHousing

  UPDATE NashvilleHousing
  SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YEs'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant 
		END 
  FROM PortfolioProject..NashvilleHousing

  -----------------------------------------------------------------------------------------------------------

  -- Remove Duplicates

  WITH RowNumCTE AS(
  SELECT *, 
		ROW_NUMBER() OVER(
		PARTITION BY ParcelID,
		PropertyAddress, 
		SalePrice,
		SaleDate,
		LegalReference
		ORDER BY
			UniqueID
			) row_num
  FROM PortfolioProject..NashvilleHousing
  )
  SELECT * 
  FROM RowNumCTE
  WHERE row_num > 1
  ORDER BY PropertyAddress

  -----------------------------------------------------------------------------------------------------------

  --DELETING THE DUPLICATE ROWS
  WITH RowNumCTE AS(
  SELECT *, 
		ROW_NUMBER() OVER(
		PARTITION BY ParcelID,
		PropertyAddress, 
		SalePrice,
		SaleDate,
		LegalReference
		ORDER BY
			UniqueID
			) row_num
  FROM PortfolioProject..NashvilleHousing
  )
  DELETE 
  FROM RowNumCTE
  WHERE row_num > 1
  --ORDER BY PropertyAddress

  -----------------------------------------------------------------------------------------------------------

  --DELETE Unused Columns

  SELECT * 
  FROM PortfolioProject..NashvilleHousing



  ALTER TABLE PortfolioProject..NashvilleHousing
  DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SalesDateConverted, OwnerSplitAddress, SaleDate 

   ALTER TABLE PortfolioProject..NashvilleHousing
  DROP COLUMN SaleDate


---------------------------------------------**THE END**-------------------------------------------------------