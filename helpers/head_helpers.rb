module HeadHelpers
  def fontawesome(kit_id)
    javascript_include_tag
    <script crossorigin="anonymous" src="https://kit.fontawesome.com/bcb8451e88.js"></script>
    script [src="https://kit.fontawesome.com/#{kit_id}.js"
      crossorigin="anonymous"]
  end
end
