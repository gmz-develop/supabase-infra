import { serve } from "https://deno.land/std/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

serve(async (req) => {
  // TODO: validar firma del proveedor externo
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
  )

  const body = await req.json().catch(() => ({}))

  const { error } = await supabase
    .from("audit_logs")
    .insert({
      actor: null,
      action: "external.customer.update",
      entity: "app.customers",
      entity_id: String(body.id ?? "unknown"),
      payload: body
    })

  if (error) return new Response(error.message, { status: 500 })
  return new Response("ok")
})
