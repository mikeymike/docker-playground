<?php

namespace LearningDocker;

class HelloWorld
{
    public function sayHelloTo($name)
    {
        echo sprintf('Hello %s', $name);
    }
}
