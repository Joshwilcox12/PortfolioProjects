--SELECT * FROM CovidDeaths
--ORDER BY 3,4

----SELECT * FROM CovidVaccinations
----ORDER BY 3,4




---- Select Data we are going to use

--SELECT Location, date, total_cases, new_cases, total_deaths, population
--FROM CovidDeaths
--ORDER BY 1,2

--Looking at Total Cases vs Total Deaths

--SELECT Location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
--FROM CovidDeaths
--WHERE location like '%state%'
--ORDER BY 1,2

--SELECT Location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as Deathpercentage, population, (total_cases/population)*100 Populationinfected
--FROM CovidDeaths
--WHERE location like '%state%'
--ORDER BY 1,2

--SELECT location, population, MAX(cast(Total_deaths as int)) as TotalDeathCount, MAX((total_cases/population))*100 as PerecentageInfected
--FROM CovidDeaths
--WHERE continent is  null
--GROUP BY location, population
--ORDER BY PerecentageInfected desc

--SELECT location, MAX(cast(Total_deaths as int)) as TotalDeathCount
--FROM CovidDeaths
--WHERE continent is not null
--GROUP BY location
--ORDER BY TotalDeathCount desc



--GlOBAL NUMBERS

--SELECT date, SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS int)) AS TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS deathper--  total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
--FROM CovidDeaths
--WHERE continent is not null
--GROUP BY date
--ORDER BY 1,2

WITH PopvsVac  (continent, location, date, population, new_vaccinations, rollingvaccination) AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as rollingvaccination
FROM CovidDeaths  dea
JOIN CovidVaccinations  vac
ON dea.location = vac.location
and dea.date =vac.date
where dea.continent is not null

)

SELECT *, (rollingvaccination/population)*100 FROM PopvsVac



--creating view to store data for later visualizations

Create View percentpopulationvaccinated as

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as rollingvaccination
FROM CovidDeaths  dea
JOIN CovidVaccinations  vac
ON dea.location = vac.location
and dea.date =vac.date
WHERE dea.continent is not null

SELECT