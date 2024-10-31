<?php

declare(strict_types=1);

namespace Gsu\Biprod\Command;

use Gadget\Console\Command\ShellCommand;

abstract class Biprod extends ShellCommand
{
    /** @var string */
    protected const CONSOLE = './bin/console';
    /** @var string */
    protected const ETL_DIR = './src/ETL/';
    /** @var string */
    protected const DAT_DIR = './var/sqlldr/';


    /**
     * @param string $parFile
     * @param string $datFile
     * @return string[]
     */
    protected function sqlldr(string $parFile, string $datFile): array
    {
        return [self::CONSOLE, 'oracle:sqlldr', self::ETL_DIR . $parFile, self::DAT_DIR . $datFile];
    }


    /**
     * @param string $sqlFile
     * @return string[]
     */
    protected function sqlplus(string $sqlFile): array
    {
        return [self::CONSOLE, 'oracle:sqlplus', self::ETL_DIR . $sqlFile];
    }
}
