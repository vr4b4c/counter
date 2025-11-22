output "counter_url" {
  description = "Counter URL"
  value       = aws_route53_record.dns.fqdn
}
