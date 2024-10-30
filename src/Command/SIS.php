<?php

declare(strict_types=1);

namespace Gsu\Biprod\Command;

use Gadget\Console\Shell\ProcessShellArgs;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

#[AsCommand('biprod:sis')]
final class SIS extends Biprod
{
    /** @inheritdoc */
    protected function getArgs(
        InputInterface $input,
        OutputInterface $output
    ): array {
        return array_map(fn(array $args) => new ProcessShellArgs($args), [
            $this->shellCommandFactory->sqlplus('./src/ETL/SISTERM.sql'),
            $this->shellCommandFactory->sqlplus('./src/ETL/SISSECT.sql'),
            $this->shellCommandFactory->sqlplus('./src/ETL/SISUSER.sql'),
            $this->shellCommandFactory->sqlplus('./src/ETL/BNR_STVCODE.sql'),
            $this->shellCommandFactory->sqlplus('./src/ETL/BNR_GORPRAC.sql'),
            $this->shellCommandFactory->sqlplus('./src/ETL/BNR_SGBSTDN.sql'),
        ]);
    }
}
