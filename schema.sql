create table public.customers (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text,
  email text,
  address text,
  notes text,
  created_at timestamptz not null default now()
);

create table public.bikes (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.customers(id) on delete cascade,
  model text not null,
  serial_no text,
  purchase_date date,
  purchase_price numeric(10,0),
  warranty_until date,
  created_at timestamptz not null default now()
);

create table public.service_records (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.customers(id) on delete cascade,
  bike_id uuid references public.bikes(id) on delete set null,
  type text not null default '維修' check (type in ('維修','諮詢','客訴','其他')),
  content text,
  record_date date not null default current_date,
  price numeric(10,0),
  status text not null default '已完成' check (status in ('待處理','維修中','已完成')),
  created_at timestamptz not null default now()
);

create index on public.bikes(customer_id);
create index on public.service_records(customer_id);
create index on public.service_records(bike_id);
create index on public.customers(phone);
create index on public.customers(name);
create index on public.bikes(model);

alter table public.customers enable row level security;
alter table public.bikes enable row level security;
alter table public.service_records enable row level security;

create policy "auth all" on public.customers for all to authenticated using (true) with check (true);
create policy "auth all" on public.bikes for all to authenticated using (true) with check (true);
create policy "auth all" on public.service_records for all to authenticated using (true) with check (true);
