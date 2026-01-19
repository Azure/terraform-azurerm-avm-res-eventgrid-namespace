module "topic_event_subscriptions" {
  source   = "./modules/topic_event_subscription"
  for_each = var.topic_event_subscriptions

  delivery_mode                    = each.value.delivery_mode
  name                             = each.value.name
  namespace_topic_id               = module.namespace_topics[each.value.topic_key].resource_id
  dead_letter_destination          = each.value.dead_letter_destination
  delivery_identity                = each.value.delivery_identity
  destination                      = each.value.destination
  event_delivery_schema            = each.value.event_delivery_schema
  event_time_to_live               = each.value.event_time_to_live
  expiration_time_utc              = each.value.expiration_time_utc
  filters_configuration            = each.value.filters_configuration
  max_delivery_count               = each.value.max_delivery_count
  receive_lock_duration_in_seconds = each.value.receive_lock_duration_in_seconds
  tags                             = each.value.tags
}
