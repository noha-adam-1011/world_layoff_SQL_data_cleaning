#EDA
select * from layoffs_staging3;

---Maximum layoffs in terms of count and percentage---
select max(total_laid_off) from layoffs_staging3;
select max(percentage_laid_off) from layoffs_staging3;
select * from layoffs_staging3 where percentage_laid_off=1
order by total_laid_off desc;

---Total Layoffs per Company---
select company, sum(total_laid_off)
from layoffs_staging3
group by company
order by 2 desc;

---Defining the date range for the data---
select min(`date`),max(`date`)
from layoffs_staging3;

---Total Layoffs per Industry---
select industry, sum(total_laid_off)
from layoffs_staging3
group by industry
order by 2 desc;

---Total Layoffs per Country---
select country, sum(total_laid_off)
from layoffs_staging3
group by country
order by 2 desc;

---Total Layoffs per Year---
select year(`date`), sum(total_laid_off)
from layoffs_staging3
group by year(`date`)
order by 1 desc;

---Total Layoffs per Stage---
select stage, sum(total_laid_off)
from layoffs_staging3
group by stage
order by 2 desc;
---Total Layoffs per Month---
select substring(`date`,1,7) as `month`, sum(total_laid_off)
from layoffs_staging3
where substring(`date`,1,7) is not null
group by `month`
order by 1;

---Rolling Total for Each Month---
with rolling_total as
(
select substring(`date`,1,7) as `month`, sum(total_laid_off) as total
from layoffs_staging3
where substring(`date`,1,7) is not null
group by `month`
order by 1
)
select `month`, total, sum(total) over(order by `month`) as rolling_total
from rolling_total;

select company, year(`date`), sum(total_laid_off)
from layoffs_staging3
group by company, year(`date`)
order by 3 desc;
---Ranking the top 5 Companies in Each Year---
with company_year (company, years, total) as
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging3
group by company, year(`date`)
),
company_ranking as 
(
select *, dense_rank() over(partition by years order by total desc) as ranking
from company_year
where years is not null 
)
select * from company_ranking where ranking <=5;
