-- Comentarios en español para columnas y tablas del esquema app

-- Tabla: app.customers
comment on table app.customers is 'Clientes sincronizados con auth.users';
comment on column app.customers.id is 'ID del usuario en auth.users (UUID)';
comment on column app.customers.email is 'Correo electrónico del cliente (único)';
comment on column app.customers.full_name is 'Nombre completo del cliente';
comment on column app.customers.avatar_url is 'URL del avatar del cliente';
comment on column app.customers.phone is 'Número de teléfono del cliente';
comment on column app.customers.created_at is 'Fecha de creación del registro';
comment on column app.customers.updated_at is 'Fecha de última actualización del registro';

-- Tabla: app.audit_logs
comment on table app.audit_logs is 'Bitácora de auditoría de acciones internas y externas';
comment on column app.audit_logs.id is 'Identificador del evento de auditoría';
comment on column app.audit_logs.at is 'Fecha y hora del evento';
comment on column app.audit_logs.actor is 'Usuario/actor que ejecutó la acción (UUID, puede ser NULL)';
comment on column app.audit_logs.action is 'Nombre de la acción ejecutada';
comment on column app.audit_logs.entity is 'Entidad afectada (por ejemplo schema.tabla)';
comment on column app.audit_logs.entity_id is 'Identificador de la entidad afectada';
comment on column app.audit_logs.payload is 'Carga útil del evento en formato JSON';

-- Tabla: app.domain_events
comment on table app.domain_events is 'Eventos de dominio para procesamiento asíncrono';
comment on column app.domain_events.id is 'Identificador del evento de dominio';
comment on column app.domain_events.kind is 'Tipo o clase del evento';
comment on column app.domain_events.payload is 'Datos del evento en formato JSON';
comment on column app.domain_events.created_at is 'Fecha de creación del evento';
comment on column app.domain_events.processed_at is 'Fecha en que el evento fue procesado (NULL si pendiente)';

