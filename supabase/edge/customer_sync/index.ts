import { serve } from "https://deno.land/std@0.224.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2?dts"

serve(async (req) => {
  // TODO: validar firma del proveedor externo
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
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
