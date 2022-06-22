use mavenfuzzyfactory;
select * from website_sessions;
select * from website_sessions where website_session_id='1059';
select * from website_pageviews where website_session_id='1059';
select * from orders where website_session_id='1059';
select distinct utm_source,utm_campaign from website_sessions;
select  website_sessions.utm_content,
count(distinct website_sessions.website_session_id) as sessions
,count(distinct orders.order_id) as orders,
count(distinct orders.order_id)/count(distinct website_sessions.website_session_id)  as session_to_order_convert
from website_sessions
left join orders
on orders.website_session_id=website_sessions.website_session_id
where website_sessions.website_session_id between 1000 and 2000
group by
1
order by 2 desc;
select * from website_pageviews;
select
website_sessions.utm_source
, count( website_sessions.utm_source) as utm_source,
website_sessions.utm_campaign,
count(website_sessions.utm_campaign) as utM_campaign,
website_sessions.http_referer as http_referer
,count(website_sessions.website_session_id) as sessions
from website_sessions 
left join website_pageviews 
on website_sessions.website_session_id=website_pageviews.website_session_id
where
website_sessions.created_at < '2012-04-12'
and website_pageviews.created_at < '2012-04-12'
group by 1
;

select 
utm_source,
utm_campaign,
http_referer,
count(distinct website_session_id) as number_of_sessions
from website_sessions
where created_at <'2012-04-12'
group by
utm_source,
utm_campaign,
http_referer
order by number_of_sessions desc;


select
count(distinct website_sessions.website_session_id) as sessions
,count(distinct orders.order_id) as orders,
count(distinct orders.order_id)/count(distinct website_sessions.website_session_id)  as session_to_order_convert
from website_sessions
left join orders
on orders.website_session_id=website_sessions.website_session_id
 where website_sessions.created_at <'2012-04-14'
 and utm_source='gsearch'
 and utm_campaign='nonbrand';



select 

year(created_at),
week(created_at),
min(date(created_at)) as week_start,
count(distinct website_session_id) as sessions
from website_sessions
where website_session_id between 100000 and 115000
group by 1,2;



select 
primary_product_id,
count(distinct case when items_purchased=1 then order_id else null end) as single_item_orders,
count(distinct case when items_purchased=2 then order_id else null end) as double_item_orders

 from orders
where order_id between 31000 and 32000
group by 1;



select 

min(date(created_at)) as week_started_at,
count(distinct website_session_id) as sessions
from website_sessions

where created_at < '2012-05-12'
and utm_source='gsearch'
and utm_campaign='nonbrand'
group by year(created_at),week(created_at);


select  website_sessions.device_type,
count(distinct website_sessions.website_session_id) as sessions
,count(distinct orders.order_id) as orders,
count(distinct orders.order_id)/count(distinct website_sessions.website_session_id)  as session_to_order_convert
from website_sessions
left join orders
on orders.website_session_id=website_sessions.website_session_id
where 
 website_sessions.created_at < '2012-05-11'
and utm_source='gsearch'
and utm_campaign='nonbrand'
group by
1;

select 

min(date(created_at)) as week_started_at,

count(distinct case when website_sessions.device_type='desktop' then website_session_id else null end) as dtop_sessions,
count(distinct case when website_sessions.device_type='mobile' then website_session_id else null end) as mob_sessions
from website_sessions

where created_at < '2012-06-09'
and created_at > '2012-04-15'
and utm_source='gsearch'
and utm_campaign='nonbrand'
group by year(created_at),week(created_at);

SELECT pageview_url,
count(distinct website_pageview_id) as pvs
from website_pageviews
where website_pageview_id < 1000
group by pageview_url
order by pvs desc;

create temporary table first_pageview
SELECT 
website_session_id,
MIN(website_pageview_id) AS MIN_PV_ID
FROM website_pageviews
where website_pageview_id <1000
group by 1;
select * from website_pageviews;
select 
first_pageview.website_session_id,
website_pageviews.pageview_url as landing_page,
count(distinct first_pageview.website_session_id)
as sessions_hitting_this_lander
from first_pageview
left join website_pageviews
on first_pageview.min_pv_id=website_pageviews.website_pageview_id
group by
website_pageviews.pageview_url;

select 
website_pageviews.pageview_url as landing_page,
count(distinct website_pageview_id) as pvs
from  website_pageviews
where created_at <'2012-06-09'
group by
pageview_url
order by
pvs desc;

select 
first_pageview.website_session_id,
website_pageviews.pageview_url as landing_page,
count(distinct first_pageview.website_session_id)
as sessions_hitting_this_lander
from first_pageview
left join website_pageviews
on first_pageview.min_pv_id=website_pageviews.website_pageview_id
group by
website_pageviews.pageview_url;

create temporary table first_pageviews
select website_session_id,
min(website_pageview_id) as min_pageview_id from 
website_pageviews
where created_at <'2012-06-14'
group by website_session_id;


create temporary table sessions_w_home_landing_page
select 
first_pageviews.website_session_id,
website_pageviews.pageview_url as landing_page
 from first_pageviews
left join website_pageviews
on website_pageviews.website_pageview_id=first_pageviews.min_pageview_id
where website_pageviews.pageview_url='/home';

select * from sessions_w_home_landing_page;


create TEMPORARY TABLE bounced_sessions
select 
 sessions_w_home_landing_page.website_session_id,
 sessions_w_home_landing_page.landing_page ,
 count(website_pageviews.website_pageview_id) as count_of_pages_viewed from
sessions_w_home_landing_page
left join website_pageviews
on website_pageviews.website_session_id=sessions_w_home_landing_page.website_session_id
group by
sessions_w_home_landing_page.website_session_id,
 sessions_w_home_landing_page.landing_page
 having count(website_pageviews.website_pageview_id)=1;
 
 select 
 count(distinct sessions_w_home_landing_page.website_session_id) as sessions,
 count(distinct bounced_sessions.website_session_id) as bounced_sessions ,
 count(distinct bounced_sessions.website_session_id)/ count(distinct sessions_w_home_landing_page.website_session_id) as bounce_rate
 from
sessions_w_home_landing_page
left join bounced_sessions
on sessions_w_home_landing_page.website_session_id=bounced_sessions.website_session_id;
order by
sessions_w_home_landing_page.website_session_id;

select 
website_sessions.website_session_id,
website_pageviews.pageview_url

,case when pageview_url='/products' then 1 else 0 end as products_page
,case when pageview_url='/the-orignal-mr-fuzzy' then 1 else 0 end as mrfuzzy_page
,case when pageview_url='/cart' then 1 else 0 end as products_page
,case when pageview_url='/shipping' then 1 else 0 end as products_page
,case when pageview_url='/billing' then 1 else 0 end as products_page
,case when pageview_url='/thank-you-for-your-order' then 1 else 0 end as products_page
 from website_sessions
 left join website_pageviews
 on website_sessions.website_session_id=website_pageviews.website_session_id
 where website_sessions.created_at > '2012-08-05'
 and website_sessions.utm_source='gsearch'
 and website_sessions.utm_campaign='nonbrand'
 and website_sessions.created_at < '2012-09-05'
 order by
 website_sessions.website_session_id,
 website_pageviews.created_at;
 
 
 create temporary table session_level_made_it_flags
 select website_session_id,
 max(products_page) as product_made_it,
 max(mrfuzzy_page) as mrfuzzy_made_it,
 max(cart_page) as cart_made_it,
 max(shipping_page) as shipping_made_it,
 max(billing_page) as billing_made_it,
 max(thankyou_page) as thankyou_made_it
 from (
 select 
website_sessions.website_session_id,
website_pageviews.pageview_url

,case when pageview_url='/products' then 1 else 0 end as products_page
,case when pageview_url='/the-orignal-mr-fuzzy' then 1 else 0 end as mrfuzzy_page
,case when pageview_url='/cart' then 1 else 0 end as cart_page
,case when pageview_url='/shipping' then 1 else 0 end as shipping_page
,case when pageview_url='/billing' then 1 else 0 end as billing_page
,case when pageview_url='/thank-you-for-your-order' then 1 else 0 end as thankyou_page
 from website_sessions
 left join website_pageviews
 on website_sessions.website_session_id=website_pageviews.website_session_id
 where website_sessions.created_at > '2012-08-05'
 and website_sessions.utm_source='gsearch'
 and website_sessions.utm_campaign='nonbrand'
 and website_sessions.created_at < '2012-09-05'
 order by
 website_sessions.website_session_id,
 website_pageviews.created_at)
 as pageview_level
 group by
 website_session_id;
 
 
 select * from session_level_made_it_flags;
 
 select
 count(distinct website_session_id) as sessions,
 count(distinct case when product_made_it=1 then website_session_id else null end) as to_products,
 count(distinct case when mrfuzzy_made_it=1 then website_session_id else null end) as to_mrfuzzy,
 count(distinct case when cart_made_it=1 then website_session_id else null end) as to_cart,
 count(distinct case when shipping_made_it=1 then website_session_id else null end) as to_shipping,
 count(distinct case when billing_made_it=1 then website_session_id else null end) as to_billing,
 count(distinct case when thankyou_made_it=1 then website_session_id else null end) as to_thankyou
 from
 session_level_made_it_flags;
 
 
 select 
 year(website_sessions.created_at) as yr,
 month(website_sessions.created_at) as mo,
 count(distinct case when utm_campaign='nonbrand' then website_sessions.website_session_id else null end) as nonbrand_session,
 count(distinct case when utm_campaign='brand' then website_sessions.website_session_id else null end) as brand_session,
  count(distinct case when utm_campaign='brand' then website_sessions.website_session_id else null end)/(count  website_sessions.website_session_id) as rate
  from 
  website_sessions
  left join orders
  on website_sessions.website_session_id=orders.website_session_id
  where website_sessions.created_at <'2012-11-27'
  and website_sessions.utm_source ='gsearch'
  group by 1,2;

select utm_content,
count(distinct website_sessions.website_session_id) as sessions,
count(distinct orders.order_id) as orders
 
from 
website_sessions
left join orders
on
website_sessions.website_session_id=orders.website_session_id
where website_sessions.created_at between '2014-01-01' and '2014-02-01'
group by 1
order by sessions desc;
select * from website_sessions;
select 
 distinct utm_source,
 count(distinct website_sessions.website_session_id ) as sessions,
 count(distinct case when device_type='mobile' then website_sessions.website_session_id else null end) as mobile_sessions,
 count(distinct case when device_type='mobile' then website_sessions.website_session_id else null end)/count(distinct website_sessions.website_session_id ) as pct_mobile
 from 
website_sessions
where website_sessions.created_at between '2012-08-22' and '2012-11-30'
group by 1;


select 
min(date(created_at)) as week_start_date ,
count(distinct case when utm_source='gsearch' and device_type='desktop' then website_sessions.website_session_id else null end) as g_dtop_sessions,
count(distinct case when utm_source='bsearch' and device_type='desktop' then website_sessions.website_session_id else null end) as b_dtop_sessions,
count(distinct case when utm_source='bsearch' and device_type='desktop' then website_sessions.website_session_id else null end)/count(distinct case when utm_source='gsearch' and device_type='desktop' then website_sessions.website_session_id else null end) as b_pct_of_btop,

count(distinct case when utm_source='gsearch' and device_type='mobile' then website_sessions.website_session_id else null end) as g_mtop_sessions,
count(distinct case when utm_source='bsearch' and device_type='mobile' then website_sessions.website_session_id else null end) as b_mtop_sessions,
count(distinct case when utm_source='bsearch' and device_type='mobile' then website_sessions.website_session_id else null end)/count(distinct case when utm_source='gsearch' and device_type='desktop' then website_sessions.website_session_id else null end) as b_pct_of_mtop
from 
website_sessions
where website_sessions.created_at between '2012-11-04' and '2012-12-22'
and utm_campaign='nonbrand'
group by yearweek(created_at);








