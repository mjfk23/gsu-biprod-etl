<?php

declare(strict_types=1);

namespace Gsu\Biprod\Command;

use mjfk23\Framework\Shell\AbstractShellCommand;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

#[AsCommand('biprod:hourly-update')]
class BiprodHourlyUpdateCommand extends AbstractShellCommand
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


    /** @inheritdoc */
    protected function getCommands(
        InputInterface $input,
        OutputInterface $output
    ): array {
        return [
            [$this->console, 'ssouser:create-file'],
            [$this->sqlldr, 'SSOUSER'],
            [$this->sqlplus, 'SSOUSER'],
            [$this->sqlplus, 'SISTERM'],
            [$this->sqlplus, 'SISSECT'],
            [$this->sqlplus, 'SISUSER'],
        ];
    }
}
