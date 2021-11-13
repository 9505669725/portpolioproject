select *
from portpoliproject1..['covid-data$']
where continent is Not Null
order by  3,4

select *
from portpoliproject1..['covid-vaccination$']
order by  3,4

select Location,date,total_cases,new_cases,total_deaths,population from portpoliproject1..['covid-data$']
order by 1,2

--looking at total cases vs total deaths

select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage from portpoliproject1..['covid-data$']
where location like '%states%'
and continent is not null
order by 1,2
--shows what %pop got covid

select Location,date,total_cases,population,total_deaths,(total_cases/population)*100 as deathpercentage from portpoliproject1..['covid-data$']
--where location like '%states%'
where continent is not null
order by 1,2

--looking at countries with  highest infection rate compared to population
select Location,population,Max(total_cases) as heighestinfectioncount,max(total_cases/population)*100 as percentpopinfected from portpoliproject1..['covid-data$']
--where location like '%states%'
where continent is not null
group by location,population
order by percentpopinfected desc

--showing countries with heighest death count per pop

select Location,Max(cast(Total_deaths as int)) as totaldeathcount from portpoliproject1..['covid-data$']
where continent is not null
--where location like '%states%'
group by location
order by totaldeathcount desc



--break things down by continent




--showing continents with heighest death count per pop

select continent,max(cast(total_deaths as int)) as totaldeathcount from portpoliproject1..['covid-data$']
where continent is not null
group by continent
--where location like '%states%'

order by totaldeathcount desc


--breaking global numbers

select date,sum(new_cases) as totalcases,sum(cast(new_deaths as int)) as totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage 
from portpoliproject1..['covid-data$']
--where location like '%states%'
where continent is not null
group by date
order by 1,2

--looking total pop vs vaccination
select dea.continent,dea.location,dea.date,dea.location,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from portpoliproject1..['covid-data$'] dea
join portpoliproject1..['covid-vaccination$'] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations from portpoliproject1..['covid-data$'] dea join 
portpoliproject1..['covid-vaccination$'] vac on dea.location=vac.location and dea.date=vac.date where dea.continent is not null order by 2,3



--temp table

create table #percentpopvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccination numeric,
rollingpeoplevaccinated numeric
)
insert into #percentpopvaccinated
select dea.continent,dea.location,dea.date,dea.location,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from portpoliproject1..['covid-data$'] dea
join portpoliproject1..['covid-vaccination$'] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

create view #percentpopvaccinated
as
select dea.continent,dea.location,dea.date,dea.location,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from portpoliproject1..['covid-data$'] dea
join portpoliproject1..['covid-vaccination$'] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

