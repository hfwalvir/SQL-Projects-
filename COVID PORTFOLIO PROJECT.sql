SELECT * 
FROM ProjectPortfolio..CovidDeaths$
WHERE Continent is not null
ORDER BY 3,4


SELECT *
FROM ProjectPortfolio..CovidVaccinations$
ORDER BY 3,4 

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM ProjectPortfolio..CovidDeaths$
WHERE Continent is not null
ORDER BY 1,2
--Looking into Positive Rate in US 
SELECT location, date, population, total_cases, (total_cases*100.0/population) as PositiveRate
FROM ProjectPortfolio..CovidDeaths$
WHERE location like '%States'
ORDER BY 1,2
--Looking into Positive rate in all countries
SELECT location, date, population, total_cases, (total_cases*100.0/population) as PositiveRate
FROM ProjectPortfolio..CovidDeaths$
WHERE Continent is not null
ORDER BY date, location

--Looking into highest positive rate and infection count in each country
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases*100.0/population)) as PercentageOfPopulationAffected
FROM ProjectPortfolio..CovidDeaths$
GROUP BY location, population
ORDER BY PercentageOfPopulationAffected DESC

--Looking into the max death count per country :
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM ProjectPortfolio..CovidDeaths$
GROUP BY location
ORDER BY TotalDeathCount DESC

--BREAK DOWN BY CONTINENT
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM ProjectPortfolio..CovidDeaths$
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS
SELECT date, SUM(new_cases) as TotalCases,SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))*100.0/SUM(new_cases) as DeathPercenatage
FROM ProjectPortfolio..CovidDeaths$
WHERE continent is not null
GROUP BY date
ORDER BY 1,2 

-- WORLD DEATH RATE 
SELECT SUM(new_cases) as TotalCases,SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))*100.0/SUM(new_cases) as DeathPercenatage
FROM ProjectPortfolio..CovidDeaths$
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2 

-- Population vs Vaccinations
Select dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM ProjectPortfolio..CovidDeaths$ as dea
JOIN ProjectPortfolio..CovidVaccinations$ as vac
ON dea.location = vac.location
and dea.date = vac.date 
WHERE dea.continent is not null 
ORDER by 2,3 

-- To find the rolling people vaccinated %
With PopvsVac (Continent, Location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM ProjectPortfolio..CovidDeaths$ as dea
JOIN ProjectPortfolio..CovidVaccinations$ as vac
ON dea.location = vac.location
and dea.date = vac.date 
WHERE dea.continent is not null 
--ORDER by 2,3 
)

Select * , (RollingPeopleVaccinated/Population)*100
FROM PopvsVac

-- TEMP TABLE
DROP TABLE IF exists #PERCENTPOPULATIONVACCINATED
CREATE TABLE #PERCENTPOPULATIONVACCINATED
(
CONTINENT nvarchar(255),
LOCATION nvarchar(255),
date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PERCENTPOPULATIONVACCINATED
Select dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM ProjectPortfolio..CovidDeaths$ as dea
JOIN ProjectPortfolio..CovidVaccinations$ as vac
ON dea.location = vac.location
and dea.date = vac.date 
WHERE dea.continent is not null 
--ORDER by 2,3 

SELECT * , (RollingPeopleVaccinated/Population)*100
FROM #PERCENTPOPULATIONVACCINATED

--creating views

CREATE VIEW PercentPopulationVaccinated as
Select dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS INT)) OVER (partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM ProjectPortfolio..CovidDeaths$ as dea
JOIN ProjectPortfolio..CovidVaccinations$ as vac
ON dea.location = vac.location
and dea.date = vac.date 
WHERE dea.continent is not null 

Select * 
FROM PercentPopulationVaccinated


