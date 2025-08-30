-- Simula llamadas autenticadas para verificar RLS
begin;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-000000000001"}', true);

-- Debe retornar 0 filas si el usuario no existe
select * from app.v1_me();
rollback;
