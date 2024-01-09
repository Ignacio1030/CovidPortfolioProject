Select* 
From PortfolioProject..CovidDeaths$
where continent is not null
order by 3,4

--Select* 
--From PortfolioProject..CovidVaccinations$
--order by 3,4

-- Data pool that we will use for case
Select location, date, total_cases, new_cases, total_deaths, population 
From PortfolioProject..CovidDeaths$
where continent is not null
order by 1, 2

--Looking at Total Cases Vs Total Deaths
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where location like '%states%'
order by 1, 2

-- Looking at Total Cases vs Population
Select Location, date, total_cases, Population, (total_cases/population) * 100 as CasePercentage
from PortfolioProject..CovidDeaths$
Where Location like '%states%'
order by 1,2

-- Looking at Countries with highest infection rate compared to population
Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)) * 100 as InfectionPercentage
From PortfolioProject..CovidDeaths$
where continent is not null
Group by location, population
order by InfectionPercentage desc

-- Looking at Countries with highest Death rate compared to population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
where continent is not null
Group by location, population
order by TotalDeathCount desc

-- by continent
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
where continent is null
Group by location
order by TotalDeathCount desc



-- GLOBAL NUMBERS

SELECT  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
ORDER BY 1,2



-- looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population) * 100
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location= vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3



-- Using a CTE

WITH VacVsPop (continent, location, date, Population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population0 * 100
FROM PortfolioProject..CovidVaccinations$ vac
JOIN PortfolioProject..CovidDeaths$ dea
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)

SELECT *, (RollingPeopleVaccinated / population) * 100 as Rolling_People_Percentage
FROM VacVsPop

