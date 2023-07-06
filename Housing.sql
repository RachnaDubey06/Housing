--cleaning data in SQL Queries 

select *
from PortfolioProject..Housing 


--standardize data format 

select SaleDate
from PortfolioProject.dbo.Housing 

Alter Table Housing 
alter column SaleDate date;

update Housing 
set SaleDate = convert (Date, SaleDate)

-- populate property address data 

select *
from PortfolioProject.dbo.Housing
--where PropertyAddress is null 
order by ParcelID 


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.Housing a
Join PortfolioProject..Housing b 
on a.ParcelID = b.ParcelID
 and a.[uniqueID] <> b.[uniqueID]
 where a.PropertyAddress is null 

update  a 
 set PropertyAddress = isnull (a.PropertyAddress, b.PropertyAddress)
 from PortfolioProject.dbo.Housing a
Join PortfolioProject..Housing b 
on a.ParcelID = b.ParcelID
 and a.[uniqueID] <> b.[uniqueID]
 where a.PropertyAddress is null 

-- breaking out address into individual columns (Address, city, state)

select PropertyAddress
from PortfolioProject..Housing

select 
substring (PropertyAddress, 1, charindex (',', PropertyAddress)-1) as Address
--charindex (',', PropertyAddress)
from PortfolioProject..Housing

select 
substring (PropertyAddress, 1, charindex (',', PropertyAddress)-1) as Address,
substring (PropertyAddress, charindex (',', PropertyAddress)+1, LEN (PropertyAddress)) as Address
from PortfolioProject..Housing

alter table Housing 
add PropertySplitAddresss nvarchar(255);

update Housing 
set PropertySplitAddress = substring (PropertyAddress, 1, charindex (',', PropertyAddress)-1)

alter table Housing 
add PropertySplitcity nvarchar(255);

update Housing 
set PropertySplitCity = substring (PropertyAddress, charindex (',', PropertyAddress)+1, LEN (PropertyAddress))

select*
from PortfolioProject..Housing


select OwnerAddress
from PortfolioProject..Housing 

select 
parsename (REPLACE(OwnerAddress, ',', '.') , 3),
parsename (REPLACE(OwnerAddress, ',', '.') , 2),
parsename (REPLACE(OwnerAddress, ',', '.') , 1)
from PortfolioProject..Housing 

Alter table Housing 
add OwnerSplitAddress nvarchar (255);

Update Housing 
set OwnersplitAddress = parsename (REPLACE(OwnerAddress, ',', '.') , 3)

Alter table Housing 
add OwnerSplitCity nvarchar (255);

Update Housing 
set OwnersplitCity = parsename (REPLACE(OwnerAddress, ',', '.') , 2)

Alter table Housing 
add OwnerSplitState nvarchar (255);

Update Housing 
set OwnersplitState = parsename (REPLACE(OwnerAddress, ',', '.') , 1)

select*
from PortfolioProject..Housing 

--change Y and N to Yes and No in "Sold as Vacant" field 

select Distinct (SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..Housing 
group by SoldAsVacant
order by 2

select SoldAsVacant, 
 Case when SoldAsVacant = 'Y' then 'Yes'
      when SoldAsVacant = 'N' then 'No'
	  Else SoldAsVacant 
	  End
From PortfolioProject..Housing


update Housing 
set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
      when SoldAsVacant = 'N' then 'No'
	  Else SoldAsVacant 
	  End

--Remove Duplicates (look rank, dense rank)

with RowNumCTE As (
select *,
 row_number () over (
 partition by ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  order by 
			  UniqueID
			  ) row_num
from PortfolioProject..Housing 
--order by ParcelID 
)
select*
--delete 
from RowNumCTE 
where row_num > 1
--Order by PropertyAddress

select *
from PortfolioProject..Housing 

--delete unsused columns 

select *
from PortfolioProject..Housing 

Alter Table  PortfolioProject..Housing
Drop Column  OwnerAddress, TaxDistrict, PropertyAddress


Alter Table  PortfolioProject..Housing
Drop Column  SaleDate