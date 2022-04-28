select *
from Protfolioproject..CovidDeaths$
Where continent is not null
order by 3,4

--select *
--from Protfolioproject..CovidVaccinations$
--order by 3,4

select Location, date,total_cases,new_cases,total_deaths,population
From Protfolioproject..CovidDeaths$
order by 1,2

-- looking at total cases vs total deaths
-- shows the likelihood of dying if you contract covid in your country

select Location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From Protfolioproject..CovidDeaths$
where location like '%India%'
order by 1,2

-- Looking at Total cases vs population
-- shows what percenatge of population got covid

select Location, date,population,total_cases,(total_deaths/population)*100 as DeathPercentage
From Protfolioproject..CovidDeaths$
--where location like '%India%'
order by 1,2

-- looking at countries with highest infection rate compared to population

select Location,population, MAX(total_cases) as HighestInfectedCount,Max(total_cases/population)*100 as PercentagePopulationInfected
From Protfolioproject..CovidDeaths$
--where location like '%India%'
Group by population,location
order by PercentagePopulationInfected desc

-- Showing Countries with Highest Death Count per Population

select Location, Max(cast(total_deaths as int)) as TotalDeathCount
From Protfolioproject..CovidDeaths$
--where location like '%India%'
Where continent is not null
Group by location
order by TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT

select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From Protfolioproject..CovidDeaths$
--where location like '%India%'
Where continent is not null
Group by continent
order by TotalDeathCount desc;

-- Showing continents with the highest death count per population

select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From Protfolioproject..CovidDeaths$
--where location like '%India%'
Where continent is not null
Group by continent
order by TotalDeathCount desc;

-- GLOBAL NUMBERS

select SUM(new_cases)as totacalCases,sum(cast(new_deaths as int)) as TotalDeaths,SUM(cast(New_Deaths as int))/SUM(new_cases)* 100 as DeathPercentage --,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From Protfolioproject..CovidDeaths$
--where location like '%India%'
Where continent is not null
--Group By date
order by 1,2



select *
From Protfolioproject..CovidDeaths$ dea
join Protfolioproject..CovidVaccinations$ vac
     On dea.location = vac.location
	 and dea.date = vac.date;

--Looking at Total Population vs Vaccinations

select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) OVER (partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
From Protfolioproject..CovidDeaths$ dea
join Protfolioproject..CovidVaccinations$ vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is  not null
order by 2,3


with PopvsVac (continent,Location,Date,Population,New_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) OVER (partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From Protfolioproject..CovidDeaths$ dea
join Protfolioproject..CovidVaccinations$ vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is  not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac;

-- TEMP TABLE
Drop table if exists #percenatagePopulationVaccinated
Create Table #percentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #percentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) OVER (partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From Protfolioproject..CovidDeaths$ dea
join Protfolioproject..CovidVaccinations$ vac
     On dea.location = vac.location
	 and dea.date = vac.date
--where dea.continent is  not null
--order by 2,3

select *, (RollingPeopleVaccinated/Population)*100
from #percentPopulationVaccinated

-- Creating View to store data for later visualization

CreateView PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) OVER (partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From Protfolioproject..CovidDeaths$ dea
join Protfolioproject..CovidVaccinations$ vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is  not null
--order by 2,3