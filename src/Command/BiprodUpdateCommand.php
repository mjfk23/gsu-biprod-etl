<?php

declare(strict_types=1);

namespace Gsu\Biprod\Command;

use Gadget\Console\Shell\AbstractShellCommand;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

abstract class BiprodUpdateCommand extends AbstractShellCommand
{
    protected string $console = './bin/console';
    protected string $sqlldr = './bin/oracle-sqlldr';
    protected string $sqlplus = './bin/oracle-sqlplus';


    /** @inheritdoc */
    protected function getWorkDir(
        InputInterface $input,
        OutputInterface $output
    ): string|null {
        return dirname(__DIR__, 2);
    }
}
