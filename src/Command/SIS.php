<?php

declare(strict_types=1);

namespace Gsu\Biprod\Command;

use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Input\InputInterface;

#[AsCommand('biprod:sis')]
final class SIS extends Biprod
{
    /** @inheritdoc */
    protected function getShellArgs(InputInterface $input): array
    {
        return [
           $this->sqlplus('SISTERM.sql'),
           $this->sqlplus('SISSECT.sql'),
           $this->sqlplus('SISUSER.sql'),
           $this->sqlplus('BNR_STVCODE.sql'),
           $this->sqlplus('BNR_GORPRAC.sql'),
           $this->sqlplus('BNR_SGBSTDN.sql'),
        ];
    }
}
