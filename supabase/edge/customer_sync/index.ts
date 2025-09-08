import { serve } from "https://deno.land/std@0.224.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2?dts"

serve(async (req) => {
  // TODO: validar firma del proveedor externo
  // En Edge Functions no se permiten variables que empiecen con SUPABASE_.
  // El workflow de deploy setea PROJECT_URL y SERVICE_ROLE_KEY.
  const supabase = createClient(
    Deno.env.get("PROJECT_URL")!,
    Deno.env.get("SERVICE_ROLE_KEY")!
  )

  const body = await req.json().catch(() => ({}))

  const { error } = await supabase
    .rpc('log_audit', {
      actor: null,
      action: 'external.customer.update',
      entity: 'app.customers',
      entity_id: String(body.id ?? 'unknown'),
      payload: body
    })

  if (error) return new Response(error.message, { status: 500 })
  return new Response("ok")
})
