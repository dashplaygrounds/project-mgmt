ALTER TABLE subscriptions
    ADD COLUMN external_customer_id varchar not null default '',
    ADD COLUMN external_plan_id varchar not null default '',    
    ADD COLUMN external_subscription_id varchar not null default  '',
    ADD COLUMN external_subscription_item_id varchar not null default ''; 