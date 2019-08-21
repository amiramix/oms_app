defmodule OmsApiWeb.InstanceController do
  use OmsApiWeb, :controller

  action_fallback OmsApiWeb.FallbackController

  # Empty as only "/instances/:id/metrics" route is required
  # For handling "/instances" add controllers to this file
end
