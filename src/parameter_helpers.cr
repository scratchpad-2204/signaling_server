# A macro to encapsulate handling for required parameters.
macro required_parameter(name, parameters, type=String)
  if {{parameters}}[{{name}}]?.nil?
    bad_request("The '#{{{name}}}' required parameter was not found in the request.",
                "Invalid data specified for request.")
  end
  begin
    {{parameters}}[{{name}}].as({{type}})
  rescue error
    bad_request("Exception caught extracting the '#{{{name}}}' parameter.\nDetails: #{error}\n#{error.backtrace.join("\n")}",
                "Invalid data specified for request.")
  end
end

# A macro to encapsulate handling for optional parameters.
macro optional_parameter(name, parameters, alternative=nil, type=String)
  if !{{parameters}}[{{name}}]?.nil?
    begin
      {{parameters}}[{{name}}].as({{type}})
    rescue error
      bad_request("Exception caught extracting the '#{{{name}}}' parameter.\nDetails: #{error}\n#{error.backtrace.join("\n")}",
                  "Invalid data specified for request.")
    end
  else
    {{alternative}}
  end
end
