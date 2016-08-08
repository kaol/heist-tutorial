<html>
  Lorem ipsum <a href="foo.html">dolor sit</a> amet...

  <div>
    <h:repeat times="2">
      Greeter:
      <span><h:hello/></span>
    </h:repeat>
  </div>
</html>

<!-- FIXME: the check for having any namespaced splices in use seems
     to be too aggressive and complain if I don't use this on the top
     level.  Investigate this. -->
<h:hello/>
