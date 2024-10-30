<?php

declare(strict_types=1);

namespace Gsu\Biprod\Factory;

final class ShellCommandFactory
{
    /** @var string[] $console */
    private array $console = ['./bin/console'];
    /** @var string[] $sqlldr */
    private array $sqlldr = ['./bin/oracle-sqlldr'];
    /** @var string[] $sqlplus */
    private array $sqlplus = ['./bin/oracle-sqlplus'];


    /**
     * @param string $dbname
     */
    public function __construct(string $dbname = '')
    {
        array_push($this->sqlldr, $dbname);
        array_push($this->sqlplus, $dbname);
    }


    /**
     * @param string $cmd
     * @param string[] $args
     * @return string[]
     */
    public function console(
        string $cmd,
        array $args = []
    ): array {
        return [...$this->console, $cmd, ...$args];
    }


    /**
     * @param string $sqlFile
     * @return string[]
     */
    public function sqlplus(string $sqlFile): array
    {
        return [...$this->sqlplus, $sqlFile];
    }


    /**
     * @param string $parFile
     * @param string $dataFile
     * @return string[]
     */
    public function sqlldr(string $parFile, string $dataFile): array
    {
        return [...$this->sqlldr, $parFile, $dataFile];
    }
}
