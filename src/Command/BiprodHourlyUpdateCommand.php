<?php

declare(strict_types=1);

namespace Gsu\Biprod\Command;

use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

#[AsCommand('biprod:hourly-update')]
class BiprodHourlyUpdateCommand extends BiprodUpdateCommand
{
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
