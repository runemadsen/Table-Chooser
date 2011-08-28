helpers do
  
  def dropdown(select_name, label_name)
    "<div class='clearfix'>
      <label for='#{select_name}'>#{label_name}</label>
      <div class='input'>
         <select name='tables[]'>
       		<option value='1'>Table 1</option>
     			<option value='2'>Table 2</option>
     			<option value='3'>Table 3</option>
     			<option value='4'>Table 4</option>
     			<option value='5'>Table 5</option>
     			<option value='6'>Table 6</option>
     			<option value='7'>Table 7</option>
     			<option value='8'>Table 8</option>
     			<option value='9'>Table 9</option>
       	</select>
      </div>
    </div>"
  end
  
end