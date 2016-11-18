module CustomButtonsHelper

  def hruled_list(collection, name = :name)
    collection.map { |e| h(e.send(name)) }.join('<hr/>').html_safe
  end

end
