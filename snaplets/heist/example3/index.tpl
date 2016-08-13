<html>
  <body>
    <h2>Simple attribute substitution</h2>
    <div id="${h:simple}">Simple attribute substitution</div>
    <h2>URL encoding example, path+query</h2>
    <a href="${h:href}">URL encoding</a>
    <h2>URL encoding example, query only</h2>
    <a href="${h:href2}">URL encoding 2</a>
    <h2>Attribute splices, using state from Application</h2>
    <h:attrsplice>
      <select name="select">
	<option h:maybeselected="red">Red</option>
	<option h:maybeselected="green">Green</option>
	<option h:maybeselected="blue">Blue</option>
      </select>
    </h:attrsplice>
    <h2>Attribute splices, using state from runtime data</h2>
    <h:attrspliceruntime>
      <select name="select">
	<option h:maybeselected="red">Red</option>
	<option h:maybeselected="green">Green</option>
	<option h:maybeselected="blue">Blue</option>
      </select>
    </h:attrspliceruntime>
  </body>
</html>
<h:relax/>
