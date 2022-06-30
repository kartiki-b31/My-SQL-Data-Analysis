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


select 
primary_product_id,
count(order_id) as orders,
sum(price_usd) as revenue,
sum(price_usd - cogs_usd) as margin,
avg(price_usd) as aov
from orders where order_id between 10000 and 11000
group by 1
order by 2 desc;

select 
year(created_at) as yr,
month(created_at) as mo,
count(distinct order_id) as number_of_sales,
sum(price_usd) as total_revenue,
sum(price_usd - cogs_usd) as total_margin,
avg(price_usd) as aov
from orders where created_at <'2013-01-04'
group by year(created_at),
month(created_at);

select 
year(website_sessions.created_at) as yr,
month(website_sessions.created_at) as mo,
count(distinct website_sessions.website_session_id) as sessions,
count(distinct orders.order_id) as orders,
count(distinct orders.order_id)/count(distinct website_sessions.website_session_id) as conv_rate,
sum(orders.price_usd)/count(distinct website_sessions.website_session_id)  as revenue_per_session,
count(distinct case when primary_product_id=1 then order_id else null end) as product_one_orders,
count(distinct case when primary_product_id=2 then order_id else null end) as product_two_orders
from website_sessions
left join orders
on website_sessions.website_session_id=orders.website_session_id

 where website_sessions.created_at < '2013-04-05'
 and website_sessions.created_at > '2012-04-01'
group by year(created_at),
month(created_at);


create temporary table products_pageviews
SELECT
website_session_id,
website_pageview_id,
created_at,
case when created_at < '2013-01-06' then 'A. Pre_Product_2'
when created_at >= '2013-01-06' then 'B. Post_Product_2'
else 'uh oh ....check logic'
end as time_period
from website_pageviews
where created_at < '2013-04-06'
and created_at > '2012-10-06'
and pageview_url='/products';

select * from products_pageviews;


CREATE TEMPORARY TABLE session_w_next_pageview_id
select 
products_pageviews.time_period,
products_pageviews.website_session_id,
min(website_pageviews.website_pageview_id) as min_next_pageview_id
from products_pageviews
left join website_pageviews
on website_pageviews.website_session_id =products_pageviews.website_session_id
and website_pageviews.website_pageview_id  > products_pageviews.website_pageview_id
group by 1,2;


select * from session_w_next_pageview_id;

create temporary table sessions_w_next_pageview_url
select session_w_next_pageview_id.time_period,
session_w_next_pageview_id.website_session_id,
website_pageviews.pageview_url as next_pageview_url
from session_w_next_pageview_id
left join website_pageviews
on website_pageviews.website_pageview_id=session_w_next_pageview_id.min_next_pageview_id;

select distinct next_pageview_url from sessions_w_next_pageview_url;

select
time_period,
count(distinct website_session_id) as sessions,
count(distinct case when next_pageview_url is not null then website_session_id else null end) as w_next_pg,
count(distinct case when next_pageview_url is not null then website_session_id else null end)/count(distinct website_session_id) as pct_w_next_page_view

from sessions_w_next_pageview_url
group by time_period;


create temporary table sessions_seeing_cart
select 
case
 when created_at < '2013-09-25' then 'A. Pre_Cross_sell'
 when created_at >= '2012-01-06' then 'B. Post_Cross_Sell'
 else 'uh oh...check logic'
 end as time_period,
 website_session_id as cart_session_id,
 website_pageview_id as cart_pageview_id
from website_pageviews
where created_at between '2013-08-25' and '2013-10-25'
and pageview_url='/cart';


select * from sessions_seeing_cart;


create temporary table cart_sessions_seeing_another_page
select 
sessions_seeing_cart.time_period,
sessions_seeing_cart.cart_session_id,
min(website_pageviews.website_pageview_id) as pv_id_after_cart
from sessions_seeing_cart
left join website_pageviews
on sessions_seeing_cart.cart_session_id=website_pageviews.website_session_id
and sessions_seeing_cart.cart_pageview_id < website_pageviews.website_pageview_id
group by
sessions_seeing_cart.time_period,
sessions_seeing_cart.cart_session_id
having min(website_pageviews.website_pageview_id) is not null;


create temporary table pre_post_sessions_orders
select 
time_period,
cart_session_id,
order_id,
items_purchased,
price_usd
from 
sessions_seeing_cart
inner join orders
on sessions_seeing_cart.cart_session_id=orders.website_session_id;


select
sessions_seeing_cart.time_period,
sessions_seeing_cart.cart_session_id,
case when cart_sessions_seeing_another_page.cart_session_id is null then 0 else 1 end as clicked_to_another_page,
case when pre_post_sessions_orders.order_id is null then 0 else 1 end as placed_order,
pre_post_sessions_orders.items_purchased,
pre_post_sessions_orders.price_usd
from 
sessions_seeing_cart
left join cart_sessions_seeing_another_page
on cart_sessions_seeing_another_page.cart_session_id=sessions_seeing_cart.cart_session_id
left join pre_post_sessions_orders
on pre_post_sessions_orders.cart_session_id=sessions_seeing_cart.cart_session_id
order by
cart_session_id;

select
time_period,
count(distinct cart_session_id) as acrt_sessions,
sum(clicked_to_another_page) as clickthroughs,
sum(clicked_to_another_page)/count(distinct cart_session_id) as cart_ctr,
sum(placed_order) as orders_plced,
sum(items_purchased) as products_purchased,
sum(items_purchased)/sum(placed_order) as product_per_order,
sum(price_usd) as revenue,
sum(price_usd)/sum(placed_order) as aov,
sum(price_usd)/count(distinct cart_session_id) as rev_per_cart_session



from(
select
sessions_seeing_cart.time_period,
sessions_seeing_cart.cart_session_id,
case when cart_sessions_seeing_another_page.cart_session_id is null then 0 else 1 end as clicked_to_another_page,
case when pre_post_sessions_orders.order_id is null then 0 else 1 end as placed_order,
pre_post_sessions_orders.items_purchased,
pre_post_sessions_orders.price_usd
from 
sessions_seeing_cart
left join cart_sessions_seeing_another_page
on cart_sessions_seeing_another_page.cart_session_id=sessions_seeing_cart.cart_session_id
left join pre_post_sessions_orders
on pre_post_sessions_orders.cart_session_id=sessions_seeing_cart.cart_session_id
order by
cart_session_id
) as full_data
group by time_period;


select 
case 
when website_sessions.created_at < '2013-12-12' then 'A. Pre_Birtheday_bear'
when website_sessions.created_at >= '2013-12-12' then 'B. Post_Birthday_Bear'
else 'uh oh...check logic'
end as time_period,
count(distinct website_sessions.website_session_id) as sesions,
count(distinct orders.order_id) as orders,
count(distinct orders.order_id)/count(distinct website_sessions.website_session_id) as conv_rate,
sum(orders.price_usd) as total_revenue,
sum(orders.items_purchased) as total_products_sold,
sum(orders.price_usd)/count(distinct orders.order_id) as average_order_value,
sum(orders.items_purchased)/count(distinct orders.order_id) as products_per_order,
sum(orders.price_usd)/count(distinct website_sessions.website_session_id) as revenue_per_session


from website_sessions
left join orders
on orders.website_session_id=website_sessions.website_session_id
where website_sessions.created_at between '2013-11-12' and '2014-01-12'
group by 1;



Create temporary table session_w_repeats
select 
new_sessions.user_id,
new_sessions.website_session_id as new_session_id,
website_sessions.website_session_id as repeat_session_id
from


(select
user_id,
website_session_id
from website_sessions
where created_at < '2014-11-01' 
and created_at >= '2014-01-01'
and is_repeat_session=0) as new_sessions
left join website_sessions
on website_sessions.user_id=new_sessions.user_id
and  website_sessions.is_repeat_session=1
and website_sessions.website_session_id >new_sessions.website_session_id
and website_sessions.created_at < '2014-11-01'
and website_sessions.created_at >= '2014-01-01';

select * from session_w_repeats;

select 
repeat_sessions,
count(distinct user_id) as users
from (
select
user_id,
count(distinct new_session_id) as new_sessions,
count(distinct repeat_session_id) as repeat_sessions
from session_w_repeats
group by 1
order by 3 desc
) as user_level
group by 1
;














