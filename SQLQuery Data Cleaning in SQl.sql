Select * From Protfolioproject.dbo.NashvillieHousing$


---standardise Date Format

select SaleDateConverted, CONVERT(Date,SaleDate)
From Protfolioproject.dbo.NashvillieHousing$

Update NashvillieHousing$
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvillieHousing$
add SaleDateCOnverted Date;

Update NashvillieHousing$
set SaleDateConverted = CONVERT(Date,SaleDate)

-- Populate Property Address data

select PropertyAddress
From Protfolioproject.dbo.NashvillieHousing$
--where PropertyAddress is  Null
--Order by ParcelID

select a.ParcelID, a.PropertyAddress,b.ParcelID
,b.PropertyAddress
, ISNULL(a.PropertyAddress,b.PropertyAddress)
from Protfolioproject.dbo.NashvillieHousing$ a
JOIN Protfolioproject.dbo.NashvillieHousing$ b
  on a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Protfolioproject.dbo.NashvillieHousing$ a
JOIN Protfolioproject.dbo.NashvillieHousing$ b
  on a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null

-- Breaking out address into Individual Columns(Address,City,State)

select propertyAddress
from Protfolioproject.dbo.NashvillieHousing$

select 
SUBSTRING(propertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as Address
,SUBSTRING(propertyAddress,CHARINDEX(',',PropertyAddress) +1, Len(PropertyAddress)) as Address
--,CHARINDEX(',',PropertyAddress)
from Protfolioproject.dbo.NashvillieHousing$


ALTER TABLE NashvillieHousing$
add PropertysplitConverted Nvarchar(255);

Update NashvillieHousing$
set PropertysplitConverted = SUBSTRING(propertyAddress,1,CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE NashvillieHousing$
add PropertysplitCity Nvarchar(255);

Update NashvillieHousing$
set PropertysplitCity = SUBSTRING(propertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

select *
from Protfolioproject.dbo.NashvillieHousing$

select OwnerAddress
from Protfolioproject.dbo.NashvillieHousing$

select 
PARSENAME(replace(OwnerAddress, ',','.'), 3)
,PARSENAME(replace(OwnerAddress, ',','.'), 2)
,PARSENAME(replace(OwnerAddress, ',','.'), 1)
from Protfolioproject.dbo.NashvillieHousing$

ALTER TABLE NashvillieHousing$
add OwnerSplitAddress Nvarchar(255);

Update NashvillieHousing$
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',','.'), 3)


ALTER TABLE NashvillieHousing$
add OwnerSPlitCity Nvarchar(255);

Update NashvillieHousing$
set OwnerSPlitCity = PARSENAME(replace(OwnerAddress, ',','.'), 2)


ALTER TABLE NashvillieHousing$
add OwnerSPlitState Nvarchar(255);

Update NashvillieHousing$
set OwnerSPlitState = PARSENAME(replace(OwnerAddress, ',','.'), 1)

--Change Y and N to Yes and No in 'Sold as vacant' field

select Distinct(SoldAsVacant), count(SoldasVacant)
from Protfolioproject.dbo.NashvillieHousing$
Group by SoldAsVacant
order by 2



select SoldAsVacant
, CASE WHEN SoldAsVacant ='Y' Then 'Yes'
       WHEN SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END
from Protfolioproject.dbo.NashvillieHousing$

Update NashvillieHousing$
set SoldAsVacant = CASE WHEN SoldAsVacant ='Y' Then 'Yes'
       WHEN SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END



--Remove Duplicates

with RowNumCTE AS(
select *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
PropertyAddress,
SalePrice,
LegalReference
 Order BY 
UNIQUEID ) row_num
from Protfolioproject.dbo.NashvillieHousing$
--order by ParcelID
)
SELECT *
--delete
from RowNumCTE
where row_num >1
--order by PropertyAddress


--deLETE Unused columns

Select * 
From Protfolioproject.dbo.NashvillieHousing$

Alter table Protfolioproject.dbo.NashvillieHousing$
Drop Column OwnerAddress,TaxDistrict,PropertyAddress


Alter table Protfolioproject.dbo.NashvillieHousing$
Drop Column saledate