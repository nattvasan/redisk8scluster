variable "service_principal_name" {
  type = string
}

variable "description" {
  description = "A description of the service principal provided for internal end-users."
  default     = null
}

variable "password_rotation_in_days" {
  description = "Number of days to add to the base timestamp to configure the rotation timestamp. When the current time has passed the rotation timestamp, the resource will trigger recreation.Conflicts with `password_end_date`, `password_rotation_in_years` and either one must be specified, not all"
  default     = null
}